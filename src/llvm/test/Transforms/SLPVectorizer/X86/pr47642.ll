; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=slp-vectorizer,instcombine -S < %s | FileCheck %s
; These code should be fully vectorized by D57059 patch

target triple = "x86_64-unknown-linux-gnu"

define <4 x i32> @foo(<4 x i32> %x, i32 %f) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[VECINIT:%.*]] = insertelement <4 x i32> undef, i32 [[F:%.*]], i64 0
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[F]], 1
; CHECK-NEXT:    [[VECINIT1:%.*]] = insertelement <4 x i32> [[VECINIT]], i32 [[ADD]], i64 1
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i32> poison, i32 [[F]], i64 0
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <2 x i32> [[TMP1]], <2 x i32> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw <2 x i32> [[TMP2]], <i32 2, i32 3>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <2 x i32> [[TMP3]], <2 x i32> poison, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>
; CHECK-NEXT:    [[VECINIT51:%.*]] = shufflevector <4 x i32> [[VECINIT1]], <4 x i32> [[TMP4]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    ret <4 x i32> [[VECINIT51]]
;
  %vecinit = insertelement <4 x i32> undef, i32 %f, i32 0
  %add = add nsw i32 %f, 1
  %vecinit1 = insertelement <4 x i32> %vecinit, i32 %add, i32 1
  %add2 = add nsw i32 %f, 2
  %vecinit3 = insertelement <4 x i32> %vecinit1, i32 %add2, i32 2
  %add4 = add nsw i32 %f, 3
  %vecinit5 = insertelement <4 x i32> %vecinit3, i32 %add4, i32 3
  ret <4 x i32> %vecinit5
}

define <4 x i32> @bar(<4 x i32> %x, i32 %f) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i32> poison, i32 [[F:%.*]], i64 0
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <2 x i32> [[TMP1]], <2 x i32> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw <2 x i32> [[TMP2]], <i32 2, i32 3>
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i32> [[TMP3]], <2 x i32> poison, <4 x i32> <i32 0, i32 0, i32 0, i32 1>
; CHECK-NEXT:    ret <4 x i32> [[SHUFFLE]]
;
  %add = add nsw i32 %f, 2
  %vecinit = insertelement <4 x i32> undef, i32 %add, i32 0
  %vecinit2 = insertelement <4 x i32> %vecinit, i32 %add, i32 1
  %vecinit4 = insertelement <4 x i32> %vecinit2, i32 %add, i32 2
  %add5 = add nsw i32 %f, 3
  %vecinit6 = insertelement <4 x i32> %vecinit4, i32 %add5, i32 3
  ret <4 x i32> %vecinit6
}