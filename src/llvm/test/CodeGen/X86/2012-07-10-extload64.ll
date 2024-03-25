; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-pc-win32 -mcpu=corei7 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-pc-win32 -mcpu=corei7 | FileCheck %s --check-prefix=X64

define void @load_store(ptr %in) {
; X86-LABEL: load_store:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; X86-NEXT:    paddw %xmm0, %xmm0
; X86-NEXT:    movq %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: load_store:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; X64-NEXT:    paddw %xmm0, %xmm0
; X64-NEXT:    movq %xmm0, (%rcx)
; X64-NEXT:    retq
entry:
  %A27 = load <4 x i16>, ptr %in, align 4
  %A28 = add <4 x i16> %A27, %A27
  store <4 x i16> %A28, ptr %in, align 4
  ret void
}

; Make sure that we store a 64bit value, even on 32bit systems.
define void @store_64(ptr %ptr) {
; X86-LABEL: store_64:
; X86:       # %bb.0: # %BB
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    xorps %xmm0, %xmm0
; X86-NEXT:    movlps %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: store_64:
; X64:       # %bb.0: # %BB
; X64-NEXT:    movq $0, (%rcx)
; X64-NEXT:    retq
BB:
  store <2 x i32> zeroinitializer, ptr %ptr
  ret void
}

define <2 x i32> @load_64(ptr %ptr) {
; X86-LABEL: load_64:
; X86:       # %bb.0: # %BB
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X86-NEXT:    retl
;
; X64-LABEL: load_64:
; X64:       # %bb.0: # %BB
; X64-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X64-NEXT:    retq
BB:
  %t = load <2 x i32>, ptr %ptr
  ret <2 x i32> %t
}