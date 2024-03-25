//===--- IndexAction.cpp -----------------------------------------*- C++-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "IndexAction.h"
#include "AST.h"
#include "Headers.h"
#include "clang-include-cleaner/Record.h"
#include "index/Relation.h"
#include "index/SymbolCollector.h"
#include "index/SymbolOrigin.h"
#include "clang/AST/ASTConsumer.h"
#include "clang/AST/ASTContext.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Index/IndexingAction.h"
#include "clang/Index/IndexingOptions.h"
#include <cstddef>
#include <functional>
#include <memory>
#include <optional>
#include <utility>

namespace clang {
namespace clangd {
namespace {

std::optional<std::string> toURI(OptionalFileEntryRef File) {
  if (!File)
    return std::nullopt;
  auto AbsolutePath = File->getFileEntry().tryGetRealPathName();
  if (AbsolutePath.empty())
    return std::nullopt;
  return URI::create(AbsolutePath).toString();
}

// Collects the nodes and edges of include graph during indexing action.
// Important: The graph generated by those callbacks might contain cycles and
// self edges.
struct IncludeGraphCollector : public PPCallbacks {
public:
  IncludeGraphCollector(const SourceManager &SM, IncludeGraph &IG)
      : SM(SM), IG(IG) {}

  // Populates everything except direct includes for a node, which represents
  // edges in the include graph and populated in inclusion directive.
  // We cannot populate the fields in InclusionDirective because it does not
  // have access to the contents of the included file.
  void FileChanged(SourceLocation Loc, FileChangeReason Reason,
                   SrcMgr::CharacteristicKind FileType,
                   FileID PrevFID) override {
    // We only need to process each file once. So we don't care about anything
    // but entries.
    if (Reason != FileChangeReason::EnterFile)
      return;

    const auto FileID = SM.getFileID(Loc);
    auto File = SM.getFileEntryRefForID(FileID);
    auto URI = toURI(File);
    if (!URI)
      return;
    auto I = IG.try_emplace(*URI).first;

    auto &Node = I->getValue();
    // Node has already been populated.
    if (Node.URI.data() == I->getKeyData()) {
#ifndef NDEBUG
      auto Digest = digestFile(SM, FileID);
      assert(Digest && Node.Digest == *Digest &&
             "Same file, different digest?");
#endif
      return;
    }
    if (auto Digest = digestFile(SM, FileID))
      Node.Digest = std::move(*Digest);
    if (FileID == SM.getMainFileID())
      Node.Flags |= IncludeGraphNode::SourceFlag::IsTU;
    Node.URI = I->getKey();
  }

  // Add edges from including files to includes.
  void InclusionDirective(SourceLocation HashLoc, const Token &IncludeTok,
                          llvm::StringRef FileName, bool IsAngled,
                          CharSourceRange FilenameRange,
                          OptionalFileEntryRef File, llvm::StringRef SearchPath,
                          llvm::StringRef RelativePath, const Module *Imported,
                          SrcMgr::CharacteristicKind FileType) override {
    auto IncludeURI = toURI(File);
    if (!IncludeURI)
      return;

    auto IncludingURI = toURI(SM.getFileEntryRefForID(SM.getFileID(HashLoc)));
    if (!IncludingURI)
      return;

    auto NodeForInclude = IG.try_emplace(*IncludeURI).first->getKey();
    auto NodeForIncluding = IG.try_emplace(*IncludingURI);

    NodeForIncluding.first->getValue().DirectIncludes.push_back(NodeForInclude);
  }

  // Sanity check to ensure we have already populated a skipped file.
  void FileSkipped(const FileEntryRef &SkippedFile, const Token &FilenameTok,
                   SrcMgr::CharacteristicKind FileType) override {
#ifndef NDEBUG
    auto URI = toURI(SkippedFile);
    if (!URI)
      return;
    auto I = IG.try_emplace(*URI);
    assert(!I.second && "File inserted for the first time on skip.");
    assert(I.first->getKeyData() == I.first->getValue().URI.data() &&
           "Node have not been populated yet");
#endif
  }

private:
  const SourceManager &SM;
  IncludeGraph &IG;
};

// Wraps the index action and reports index data after each translation unit.
class IndexAction : public ASTFrontendAction {
public:
  IndexAction(std::shared_ptr<SymbolCollector> C,
              std::unique_ptr<include_cleaner::PragmaIncludes> PI,
              const index::IndexingOptions &Opts,
              std::function<void(SymbolSlab)> SymbolsCallback,
              std::function<void(RefSlab)> RefsCallback,
              std::function<void(RelationSlab)> RelationsCallback,
              std::function<void(IncludeGraph)> IncludeGraphCallback)
      : SymbolsCallback(SymbolsCallback), RefsCallback(RefsCallback),
        RelationsCallback(RelationsCallback),
        IncludeGraphCallback(IncludeGraphCallback), Collector(C),
        PI(std::move(PI)), Opts(Opts) {
    this->Opts.ShouldTraverseDecl = [this](const Decl *D) {
      // Many operations performed during indexing is linear in terms of depth
      // of the decl (USR generation, name lookups, figuring out role of a
      // reference are some examples). Since we index all the decls nested
      // inside, it becomes quadratic. So we give up on nested symbols.
      if (isDeeplyNested(D))
        return false;
      auto &SM = D->getASTContext().getSourceManager();
      auto FID = SM.getFileID(SM.getExpansionLoc(D->getLocation()));
      if (!FID.isValid())
        return true;
      return Collector->shouldIndexFile(FID);
    };
  }

  std::unique_ptr<ASTConsumer>
  CreateASTConsumer(CompilerInstance &CI, llvm::StringRef InFile) override {
    PI->record(CI.getPreprocessor());
    if (IncludeGraphCallback != nullptr)
      CI.getPreprocessor().addPPCallbacks(
          std::make_unique<IncludeGraphCollector>(CI.getSourceManager(), IG));

    return index::createIndexingASTConsumer(Collector, Opts,
                                            CI.getPreprocessorPtr());
  }

  bool BeginInvocation(CompilerInstance &CI) override {
    // We want all comments, not just the doxygen ones.
    CI.getLangOpts().CommentOpts.ParseAllComments = true;
    CI.getLangOpts().RetainCommentsFromSystemHeaders = true;
    // Index the whole file even if there are warnings and -Werror is set.
    // Avoids some analyses too. Set in two places as we're late to the party.
    CI.getDiagnosticOpts().IgnoreWarnings = true;
    CI.getDiagnostics().setIgnoreAllWarnings(true);
    // Instruct the parser to ask our ASTConsumer if it should skip function
    // bodies. The ASTConsumer will take care of skipping only functions inside
    // the files that we have already processed.
    CI.getFrontendOpts().SkipFunctionBodies = true;
    return true;
  }

  void EndSourceFileAction() override {
    SymbolsCallback(Collector->takeSymbols());
    if (RefsCallback != nullptr)
      RefsCallback(Collector->takeRefs());
    if (RelationsCallback != nullptr)
      RelationsCallback(Collector->takeRelations());
    if (IncludeGraphCallback != nullptr) {
#ifndef NDEBUG
      // This checks if all nodes are initialized.
      for (const auto &Node : IG)
        assert(Node.getKeyData() == Node.getValue().URI.data());
#endif
      IncludeGraphCallback(std::move(IG));
    }
  }

private:
  std::function<void(SymbolSlab)> SymbolsCallback;
  std::function<void(RefSlab)> RefsCallback;
  std::function<void(RelationSlab)> RelationsCallback;
  std::function<void(IncludeGraph)> IncludeGraphCallback;
  std::shared_ptr<SymbolCollector> Collector;
  std::unique_ptr<include_cleaner::PragmaIncludes> PI;
  index::IndexingOptions Opts;
  IncludeGraph IG;
};

} // namespace

std::unique_ptr<FrontendAction> createStaticIndexingAction(
    SymbolCollector::Options Opts,
    std::function<void(SymbolSlab)> SymbolsCallback,
    std::function<void(RefSlab)> RefsCallback,
    std::function<void(RelationSlab)> RelationsCallback,
    std::function<void(IncludeGraph)> IncludeGraphCallback) {
  index::IndexingOptions IndexOpts;
  IndexOpts.SystemSymbolFilter =
      index::IndexingOptions::SystemSymbolFilterKind::All;
  // We index function-local classes and its member functions only.
  IndexOpts.IndexFunctionLocals = true;
  Opts.CollectIncludePath = true;
  if (Opts.Origin == SymbolOrigin::Unknown)
    Opts.Origin = SymbolOrigin::Static;
  Opts.StoreAllDocumentation = false;
  if (RefsCallback != nullptr) {
    Opts.RefFilter = RefKind::All;
    Opts.RefsInHeaders = true;
  }
  auto PragmaIncludes = std::make_unique<include_cleaner::PragmaIncludes>();
  Opts.PragmaIncludes = PragmaIncludes.get();
  return std::make_unique<IndexAction>(std::make_shared<SymbolCollector>(Opts),
                                       std::move(PragmaIncludes), IndexOpts,
                                       SymbolsCallback, RefsCallback,
                                       RelationsCallback, IncludeGraphCallback);
}

} // namespace clangd
} // namespace clang
