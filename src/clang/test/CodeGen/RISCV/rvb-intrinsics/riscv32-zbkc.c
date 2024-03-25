// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple riscv32 -target-feature +zbkc -emit-llvm %s -o - \
// RUN:     -disable-O0-optnone | opt -S -passes=mem2reg \
// RUN:     | FileCheck %s  -check-prefix=RV32ZBKC

#include <stdint.h>

// RV32ZBKC-LABEL: @clmul_32(
// RV32ZBKC-NEXT:  entry:
// RV32ZBKC-NEXT:    [[TMP0:%.*]] = call i32 @llvm.riscv.clmul.i32(i32 [[A:%.*]], i32 [[B:%.*]])
// RV32ZBKC-NEXT:    ret i32 [[TMP0]]
//
uint32_t clmul_32(uint32_t a, uint32_t b) {
  return __builtin_riscv_clmul_32(a, b);
}

// RV32ZBKC-LABEL: @clmulh_32(
// RV32ZBKC-NEXT:  entry:
// RV32ZBKC-NEXT:    [[TMP0:%.*]] = call i32 @llvm.riscv.clmulh.i32(i32 [[A:%.*]], i32 [[B:%.*]])
// RV32ZBKC-NEXT:    ret i32 [[TMP0]]
//
uint32_t clmulh_32(uint32_t a, uint32_t b) {
  return __builtin_riscv_clmulh_32(a, b);
}