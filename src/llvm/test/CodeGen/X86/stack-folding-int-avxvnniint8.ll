; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O3 -disable-peephole -mtriple=x86_64-unknown-unknown -mattr=+avxvnniint8 < %s | FileCheck %s

declare <4 x i32> @llvm.x86.avx2.vpdpbssd.128(<4 x i32>, <4 x i32>, <4 x i32>)
declare <4 x i32> @llvm.x86.avx2.vpdpbssds.128(<4 x i32>, <4 x i32>, <4 x i32>)
declare <8 x i32> @llvm.x86.avx2.vpdpbssd.256(<8 x i32>, <8 x i32>, <8 x i32>)
declare <8 x i32> @llvm.x86.avx2.vpdpbssds.256(<8 x i32>, <8 x i32>, <8 x i32>)
declare <4 x i32> @llvm.x86.avx2.vpdpbsud.128(<4 x i32>, <4 x i32>, <4 x i32>)
declare <4 x i32> @llvm.x86.avx2.vpdpbsuds.128(<4 x i32>, <4 x i32>, <4 x i32>)
declare <8 x i32> @llvm.x86.avx2.vpdpbsud.256(<8 x i32>, <8 x i32>, <8 x i32>)
declare <8 x i32> @llvm.x86.avx2.vpdpbsuds.256(<8 x i32>, <8 x i32>, <8 x i32>)
declare <4 x i32> @llvm.x86.avx2.vpdpbuud.128(<4 x i32>, <4 x i32>, <4 x i32>)
declare <4 x i32> @llvm.x86.avx2.vpdpbuuds.128(<4 x i32>, <4 x i32>, <4 x i32>)
declare <8 x i32> @llvm.x86.avx2.vpdpbuud.256(<8 x i32>, <8 x i32>, <8 x i32>)
declare <8 x i32> @llvm.x86.avx2.vpdpbuuds.256(<8 x i32>, <8 x i32>, <8 x i32>)

define <4 x i32> @stack_fold_vpdpbssd(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbssd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbssd {{[-0-9]+}}(%r{{[sb]}}p), %xmm1, %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbssd.128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}

define <4 x i32> @stack_fold_vpdpbssd_commuted(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbssd_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbssd {{[-0-9]+}}(%r{{[sb]}}p), %xmm1, %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbssd.128(<4 x i32> %a0, <4 x i32> %a2, <4 x i32> %a1)
  ret <4 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbssd_256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbssd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbssd {{[-0-9]+}}(%r{{[sb]}}p), %ymm1, %ymm0 # 32-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbssd.256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2)
  ret <8 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbssd_256_commuted(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbssd_256_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbssd {{[-0-9]+}}(%r{{[sb]}}p), %ymm1, %ymm0 # 32-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbssd.256(<8 x i32> %a0, <8 x i32> %a2, <8 x i32> %a1)
  ret <8 x i32> %2
}

define <4 x i32> @stack_fold_vpdpbssds(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbssds:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbssds {{[-0-9]+}}(%r{{[sb]}}p), %xmm1, %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbssds.128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}

define <4 x i32> @stack_fold_vpdpbssds_commuted(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbssds_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbssds {{[-0-9]+}}(%r{{[sb]}}p), %xmm1, %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbssds.128(<4 x i32> %a0, <4 x i32> %a2, <4 x i32> %a1)
  ret <4 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbssds_256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbssds_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbssds {{[-0-9]+}}(%r{{[sb]}}p), %ymm1, %ymm0 # 32-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbssds.256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2)
  ret <8 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbssds_256_commuted(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbssds_256_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbssds {{[-0-9]+}}(%r{{[sb]}}p), %ymm1, %ymm0 # 32-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbssds.256(<8 x i32> %a0, <8 x i32> %a2, <8 x i32> %a1)
  ret <8 x i32> %2
}

define <4 x i32> @stack_fold_vpdpbsud(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbsud:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbsud {{[-0-9]+}}(%r{{[sb]}}p), %xmm1, %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbsud.128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}

define <4 x i32> @stack_fold_vpdpbsud_commuted(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbsud_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vmovaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; CHECK-NEXT:    vpdpbsud %xmm1, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbsud.128(<4 x i32> %a0, <4 x i32> %a2, <4 x i32> %a1)
  ret <4 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbsud_256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbsud_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbsud {{[-0-9]+}}(%r{{[sb]}}p), %ymm1, %ymm0 # 32-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbsud.256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2)
  ret <8 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbsud_256_commuted(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbsud_256_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vmovups {{[-0-9]+}}(%r{{[sb]}}p), %ymm2 # 32-byte Reload
; CHECK-NEXT:    vpdpbsud %ymm1, %ymm2, %ymm0
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbsud.256(<8 x i32> %a0, <8 x i32> %a2, <8 x i32> %a1)
  ret <8 x i32> %2
}

define <4 x i32> @stack_fold_vpdpbsuds(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbsuds:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbsuds {{[-0-9]+}}(%r{{[sb]}}p), %xmm1, %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbsuds.128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}

define <4 x i32> @stack_fold_vpdpbsuds_commuted(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbsuds_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vmovaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; CHECK-NEXT:    vpdpbsuds %xmm1, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbsuds.128(<4 x i32> %a0, <4 x i32> %a2, <4 x i32> %a1)
  ret <4 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbsuds_256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbsuds_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbsuds {{[-0-9]+}}(%r{{[sb]}}p), %ymm1, %ymm0 # 32-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbsuds.256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2)
  ret <8 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbsuds_256_commuted(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbsuds_256_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vmovups {{[-0-9]+}}(%r{{[sb]}}p), %ymm2 # 32-byte Reload
; CHECK-NEXT:    vpdpbsuds %ymm1, %ymm2, %ymm0
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbsuds.256(<8 x i32> %a0, <8 x i32> %a2, <8 x i32> %a1)
  ret <8 x i32> %2
}

define <4 x i32> @stack_fold_vpdpbuud(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbuud:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbuud {{[-0-9]+}}(%r{{[sb]}}p), %xmm1, %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbuud.128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}

define <4 x i32> @stack_fold_vpdpbuud_commuted(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbuud_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbuud {{[-0-9]+}}(%r{{[sb]}}p), %xmm1, %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbuud.128(<4 x i32> %a0, <4 x i32> %a2, <4 x i32> %a1)
  ret <4 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbuud_256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbuud_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbuud {{[-0-9]+}}(%r{{[sb]}}p), %ymm1, %ymm0 # 32-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbuud.256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2)
  ret <8 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbuud_256_commuted(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbuud_256_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbuud {{[-0-9]+}}(%r{{[sb]}}p), %ymm1, %ymm0 # 32-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbuud.256(<8 x i32> %a0, <8 x i32> %a2, <8 x i32> %a1)
  ret <8 x i32> %2
}

define <4 x i32> @stack_fold_vpdpbuuds(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbuuds:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbuuds {{[-0-9]+}}(%r{{[sb]}}p), %xmm1, %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbuuds.128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}

define <4 x i32> @stack_fold_vpdpbuuds_commuted(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbuuds_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbuuds {{[-0-9]+}}(%r{{[sb]}}p), %xmm1, %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbuuds.128(<4 x i32> %a0, <4 x i32> %a2, <4 x i32> %a1)
  ret <4 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbuuds_256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbuuds_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbuuds {{[-0-9]+}}(%r{{[sb]}}p), %ymm1, %ymm0 # 32-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbuuds.256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2)
  ret <8 x i32> %2
}

define <8 x i32> @stack_fold_vpdpbuuds_256_commuted(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; CHECK-LABEL: stack_fold_vpdpbuuds_256_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovups %ymm2, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vpdpbuuds {{[-0-9]+}}(%r{{[sb]}}p), %ymm1, %ymm0 # 32-byte Folded Reload
; CHECK-NEXT:    retq
  %1 = tail call <2 x i64> asm sideeffect "nop", "=x,~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{flags}"()
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbuuds.256(<8 x i32> %a0, <8 x i32> %a2, <8 x i32> %a1)
  ret <8 x i32> %2
}