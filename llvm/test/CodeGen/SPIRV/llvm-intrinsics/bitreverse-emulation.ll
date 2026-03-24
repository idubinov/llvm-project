; Test bitreverse emulation when SPV_KHR_bit_instructions is NOT available.
; This test verifies that the bitreverse emulation is generated for all supported types.

; RUN: llc -O0 -verify-machineinstrs -mtriple=spirv64-unknown-unknown %s -o - | FileCheck %s --check-prefix=CHECK-SPIRV
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-unknown-unknown %s -o - -filetype=obj | spirv-val %}

; SPV_KHR_bit_instructions extension is not enabled, so OpBitReverse must NOT be used
; CHECK-SPIRV-NOT: OpBitReverse

; Instead, we should see the emulation using shift and bitwise operations.
; CHECK-SPIRV-DAG: OpShiftRightLogical
; CHECK-SPIRV-DAG: OpShiftLeftLogical
; CHECK-SPIRV-DAG: OpBitwiseAnd
; CHECK-SPIRV-DAG: OpBitwiseOr

; Function Attrs: nounwind
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

; Function Attrs: nounwind
define spir_kernel void @test_bitreverse_v2(<2 x i8> %a, <2 x i16> %b, <2 x i32> %c, <2 x i64> %d, ptr addrspace(1) %res) #0 {
entry:
  %call8 = call <2 x i8> @llvm.bitreverse.v2i8(<2 x i8> %a)
  store <2 x i8> %call8, ptr addrspace(1) %res, align 2

  %call16 = call <2 x i16> @llvm.bitreverse.v2i16(<2 x i16> %b)
  store <2 x i16> %call16, ptr addrspace(1) %res, align 4

  %call32 = call <2 x i32> @llvm.bitreverse.v2i32(<2 x i32> %c)
  store <2 x i32> %call32, ptr addrspace(1) %res, align 8

  %call64 = call <2 x i64> @llvm.bitreverse.v2i64(<2 x i64> %d)
  store <2 x i64> %call64, ptr addrspace(1) %res, align 16

  ret void
}

; Function Attrs: nounwind
define spir_kernel void @test_bitreverse_v4(<4 x i8> %a, <4 x i16> %b, <4 x i32> %c, <4 x i64> %d, ptr addrspace(1) %res) #0 {
entry:
  %call8 = call <4 x i8> @llvm.bitreverse.v4i8(<4 x i8> %a)
  store <4 x i8> %call8, ptr addrspace(1) %res, align 4

  %call16 = call <4 x i16> @llvm.bitreverse.v4i16(<4 x i16> %b)
  store <4 x i16> %call16, ptr addrspace(1) %res, align 8

  %call32 = call <4 x i32> @llvm.bitreverse.v4i32(<4 x i32> %c)
  store <4 x i32> %call32, ptr addrspace(1) %res, align 16

  %call64 = call <4 x i64> @llvm.bitreverse.v4i64(<4 x i64> %d)
  store <4 x i64> %call64, ptr addrspace(1) %res, align 32

  ret void
}

; Function Attrs: nounwind
define spir_kernel void @test_bitreverse_v8(<8 x i8> %a, <8 x i16> %b, <8 x i32> %c, ptr addrspace(1) %res) #0 {
entry:
  %call8 = call <8 x i8> @llvm.bitreverse.v8i8(<8 x i8> %a)
  store <8 x i8> %call8, ptr addrspace(1) %res, align 8

  %call16 = call <8 x i16> @llvm.bitreverse.v8i16(<8 x i16> %b)
  store <8 x i16> %call16, ptr addrspace(1) %res, align 16

  %call32 = call <8 x i32> @llvm.bitreverse.v8i32(<8 x i32> %c)
  store <8 x i32> %call32, ptr addrspace(1) %res, align 32

  ret void
}

; Function Attrs: nounwind
define spir_kernel void @test_bitreverse_v16(<16 x i8> %a, <16 x i16> %b, <16 x i32> %c, ptr addrspace(1) %res) #0 {
entry:
  %call8 = call <16 x i8> @llvm.bitreverse.v16i8(<16 x i8> %a)
  store <16 x i8> %call8, ptr addrspace(1) %res, align 16

  %call16 = call <16 x i16> @llvm.bitreverse.v16i16(<16 x i16> %b)
  store <16 x i16> %call16, ptr addrspace(1) %res, align 32

  %call32 = call <16 x i32> @llvm.bitreverse.v16i32(<16 x i32> %c)
  store <16 x i32> %call32, ptr addrspace(1) %res, align 64

  ret void
}

; Scalar declarations
declare i8 @llvm.bitreverse.i8(i8)
declare i16 @llvm.bitreverse.i16(i16)
declare i32 @llvm.bitreverse.i32(i32)
declare i64 @llvm.bitreverse.i64(i64)

; 2-element vector declarations
declare <2 x i8>  @llvm.bitreverse.v2i8(<2 x i8>)
declare <2 x i16> @llvm.bitreverse.v2i16(<2 x i16>)
declare <2 x i32> @llvm.bitreverse.v2i32(<2 x i32>)
declare <2 x i64> @llvm.bitreverse.v2i64(<2 x i64>)

; 4-element vector declarations
declare <4 x i8>  @llvm.bitreverse.v4i8(<4 x i8>)
declare <4 x i16> @llvm.bitreverse.v4i16(<4 x i16>)
declare <4 x i32> @llvm.bitreverse.v4i32(<4 x i32>)
declare <4 x i64> @llvm.bitreverse.v4i64(<4 x i64>)

; 8-element vector declarations
declare <8 x i8>  @llvm.bitreverse.v8i8(<8 x i8>)
declare <8 x i16> @llvm.bitreverse.v8i16(<8 x i16>)
declare <8 x i32> @llvm.bitreverse.v8i32(<8 x i32>)

; 16-element vector declarations
declare <16 x i8>  @llvm.bitreverse.v16i8(<16 x i8>)
declare <16 x i16> @llvm.bitreverse.v16i16(<16 x i16>)
declare <16 x i32> @llvm.bitreverse.v16i32(<16 x i32>)
