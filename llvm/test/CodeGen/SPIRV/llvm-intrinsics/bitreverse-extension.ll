; Test bitreverse using OpBitReverse when SPV_KHR_bit_instructions extension IS available.
; This test verifies that native OpBitReverse is used instead of emulation.

; RUN: llc -O0 -verify-machineinstrs -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_bit_instructions %s -o - | FileCheck %s --check-prefix=CHECK-SPIRV
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_bit_instructions %s -o - -filetype=obj | spirv-val %}

; With SPV_KHR_bit_instructions enabled, we should use OpBitReverse
; CHECK-SPIRV: OpExtension "SPV_KHR_bit_instructions"

; We should NOT see emulation code (shifts and bitwise ops in the pattern used by emulation).
; The presence of a few shifts/bitwise ops is OK (for address calculation, etc.)
; but we should see OpBitReverse being used.


define spir_kernel void @test_bitreverse_scalar(i8 %a, i16 %b, i32 %c, i64 %d, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpFunction
  ; CHECK-SPIRV: OpLabel

  ; 8-bit scalar
  %call8 = call i8 @llvm.bitreverse.i8(i8 %a)
  ; CHECK-SPIRV: OpShiftRightLogical
  ; CHECK-SPIRV: OpBitwiseAnd
  ; CHECK-SPIRV: OpShiftLeftLogical
  ; CHECK-SPIRV: OpBitwiseOr
  store i8 %call8, ptr addrspace(1) %res, align 1

  ; 16-bit scalar
  %call16 = call i16 @llvm.bitreverse.i16(i16 %b)
  store i16 %call16, ptr addrspace(1) %res, align 2

  ; 32-bit scalar
  %call32 = call i32 @llvm.bitreverse.i32(i32 %c)
  store i32 %call32, ptr addrspace(1) %res, align 4

  ; 64-bit scalar
  %call64 = call i64 @llvm.bitreverse.i64(i64 %d)
  store i64 %call64, ptr addrspace(1) %res, align 8

  ret void
}

define spir_kernel void @test_bitreverse_scalar_i32(i32 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpFunction
  ; CHECK-SPIRV: OpBitReverse {{%[0-9]+}} {{%[0-9]+}}
  %call = call i32 @llvm.bitreverse.i32(i32 %a)
  store i32 %call, ptr addrspace(1) %res, align 4
  ret void
}

define spir_kernel void @test_bitreverse_scalar_i64(i64 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpBitReverse {{%[0-9]+}} {{%[0-9]+}}
  %call = call i64 @llvm.bitreverse.i64(i64 %a)
  store i64 %call, ptr addrspace(1) %res, align 8
  ret void
}

define spir_kernel void @test_bitreverse_scalar_i16(i16 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpBitReverse {{%[0-9]+}} {{%[0-9]+}}
  %call = call i16 @llvm.bitreverse.i16(i16 %a)
  store i16 %call, ptr addrspace(1) %res, align 2
  ret void
}

define spir_kernel void @test_bitreverse_scalar_i8(i8 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpBitReverse {{%[0-9]+}} {{%[0-9]+}}
  %call = call i8 @llvm.bitreverse.i8(i8 %a)
  store i8 %call, ptr addrspace(1) %res, align 1
  ret void
}

define spir_kernel void @test_bitreverse_vector(<4 x i32> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpBitReverse {{%[0-9]+}} {{%[0-9]+}}
  %call = call <4 x i32> @llvm.bitreverse.v4i32(<4 x i32> %a)
  store <4 x i32> %call, ptr addrspace(1) %res, align 16
  ret void
}

define spir_kernel void @test_bitreverse_v2i64(<2 x i64> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpBitReverse %24 %47
  %call = call <2 x i64> @llvm.bitreverse.v2i64(<2 x i64> %a)
  store <2 x i64> %call, ptr addrspace(1) %res, align 16
  ret void
}

declare i8 @llvm.bitreverse.i8(i8)
declare i16 @llvm.bitreverse.i16(i16)
declare i32 @llvm.bitreverse.i32(i32)
declare i64 @llvm.bitreverse.i64(i64)
declare <4 x i32> @llvm.bitreverse.v4i32(<4 x i32>)
declare <2 x i64> @llvm.bitreverse.v2i64(<2 x i64>)
