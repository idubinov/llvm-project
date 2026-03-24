; Test bitreverse for all popular types (scalars and vectors of 8, 16, 32, 64 bits)
; This comprehensive test covers the full range of supported types.

; RUN: llc -O0 -verify-machineinstrs -mtriple=spirv64-unknown-unknown %s -o - | FileCheck %s --check-prefix=CHECK-EMULATION
; RUN: llc -O0 -verify-machineinstrs -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_bit_instructions %s -o - | FileCheck %s --check-prefix=CHECK-NATIVE
; RUN: %if spirv-tools %{ llc -O0 -verify-machineinstrs -mtriple=spirv64-unknown-unknown %s -o - -filetype=obj | spirv-val %}
; RUN: %if spirv-tools %{ llc -O0 -verify-machineinstrs -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_bit_instructions %s -o - -filetype=obj | spirv-val %}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Scalar types - 8, 16, 32, 64 bits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define spir_kernel void @test_scalar_i8(i8 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: Begin function test_scalar_i8
  ; CHECK-EMULATION-NOT: OpBitReverse
  ; CHECK-EMULATION: OpShiftRightLogical
  ; CHECK-EMULATION: OpShiftLeftLogical
  ; CHECK-EMULATION: OpBitwiseAnd
  ; CHECK-EMULATION: OpBitwiseOr
  ; CHECK-NATIVE-LABEL: Begin function test_scalar_i8
  ; CHECK-NATIVE:OpBitReverse
  %call = call i8 @llvm.bitreverse.i8(i8 %a)
  store i8 %call, ptr addrspace(1) %res, align 1
  ret void
}

define spir_kernel void @test_scalar_i16(i16 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: Begin function test_scalar_i16
  ; CHECK-EMULATION: OpShiftRightLogical
  ; CHECK-EMULATION: OpShiftLeftLogical
  ; CHECK-EMULATION: OpBitwiseAnd
  ; CHECK-EMULATION: OpBitwiseOr
  ; CHECK-NATIVE-LABEL: Begin function test_scalar_i16
  ; CHECK-NATIVE: OpBitReverse
  %call = call i16 @llvm.bitreverse.i16(i16 %a)
  store i16 %call, ptr addrspace(1) %res, align 2
  ret void
}

define spir_kernel void @test_scalar_i32(i32 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL:  Begin function test_scalar_i32
  ; CHECK-EMULATION: OpShiftRightLogical
  ; CHECK-EMULATION: OpShiftLeftLogical
  ; CHECK-EMULATION: OpBitwiseAnd
  ; CHECK-EMULATION: OpBitwiseOr
  ; CHECK-NATIVE-LABEL:  Begin function test_scalar_i32
  ; CHECK-NATIVE: OpBitReverse
  %call = call i32 @llvm.bitreverse.i32(i32 %a)
  store i32 %call, ptr addrspace(1) %res, align 4
  ret void
}

define spir_kernel void @test_scalar_i64(i64 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: Begin function test_scalar_i64
  ; CHECK-EMULATION: OpShiftRightLogical
  ; CHECK-EMULATION: OpShiftLeftLogical
  ; CHECK-EMULATION: OpBitwiseAnd
  ; CHECK-EMULATION: OpBitwiseOr
  ; CHECK-NATIVE-LABEL: Begin function test_scalar_i64
  ; CHECK-NATIVE: OpBitReverse
  %call = call i64 @llvm.bitreverse.i64(i64 %a)
  store i64 %call, ptr addrspace(1) %res, align 8
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 2-element vectors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define spir_kernel void @test_v2i8(<2 x i8> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: Begin function test_v2i8
  ; CHECK-EMULATION: OpShiftRightLogical
  ; CHECK-EMULATION: OpShiftLeftLogical
  ; CHECK-EMULATION: OpBitwiseAnd
  ; CHECK-EMULATION: OpBitwiseOr
  ; CHECK-NATIVE-LABEL: Begin function test_v2i8
  ; CHECK-NATIVE: OpBitReverse
  %call = call <2 x i8> @llvm.bitreverse.v2i8(<2 x i8> %a)
  store <2 x i8> %call, ptr addrspace(1) %res, align 2
  ret void
}

define spir_kernel void @test_v2i16(<2 x i16> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: Begin function test_v2i16
  ; CHECK-EMULATION: OpShiftRightLogical
  ; CHECK-EMULATION: OpShiftLeftLogical
  ; CHECK-EMULATION: OpBitwiseAnd
  ; CHECK-EMULATION: OpBitwiseOr
  ; CHECK-NATIVE-LABEL: Begin function test_v2i16
  ; CHECK-NATIVE: OpBitReverse
  %call = call <2 x i16> @llvm.bitreverse.v2i16(<2 x i16> %a)
  store <2 x i16> %call, ptr addrspace(1) %res, align 4
  ret void
}

define spir_kernel void @test_v2i32(<2 x i32> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: Begin function test_v2i32
  ; CHECK-EMULATION: OpShiftRightLogical
  ; CHECK-EMULATION: OpShiftLeftLogical
  ; CHECK-EMULATION: OpBitwiseAnd
  ; CHECK-EMULATION: OpBitwiseOr
  ; CHECK-NATIVE-LABEL: Begin function test_v2i32
  ; CHECK-NATIVE: OpBitReverse
  %call = call <2 x i32> @llvm.bitreverse.v2i32(<2 x i32> %a)
  store <2 x i32> %call, ptr addrspace(1) %res, align 8
  ret void
}

define spir_kernel void @test_v2i64(<2 x i64> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: Begin function test_v2i64
  ; CHECK-EMULATION: OpShiftRightLogical
  ; CHECK-EMULATION: OpShiftLeftLogical
  ; CHECK-EMULATION: OpBitwiseAnd
  ; CHECK-EMULATION: OpBitwiseOr
  ; CHECK-NATIVE-LABEL: Begin function test_v2i64
  ; CHECK-NATIVE: OpBitReverse
  %call = call <2 x i64> @llvm.bitreverse.v2i64(<2 x i64> %a)
  store <2 x i64> %call, ptr addrspace(1) %res, align 16
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Declarations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Scalar
declare i8 @llvm.bitreverse.i8(i8)
declare i16 @llvm.bitreverse.i16(i16)
declare i32 @llvm.bitreverse.i32(i32)
declare i64 @llvm.bitreverse.i64(i64)

; 2-element vectors
declare <2 x i8>  @llvm.bitreverse.v2i8(<2 x i8>)
declare <2 x i16> @llvm.bitreverse.v2i16(<2 x i16>)
declare <2 x i32> @llvm.bitreverse.v2i32(<2 x i32>)
declare <2 x i64> @llvm.bitreverse.v2i64(<2 x i64>)
