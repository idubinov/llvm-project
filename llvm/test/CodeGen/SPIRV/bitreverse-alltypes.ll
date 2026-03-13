; Test bitreverse for all popular types (scalars and vectors of 8, 16, 32, 64 bits)
; This comprehensive test covers the full range of supported types

; RUN: llc -O0 -mtriple=spirv64-unknown-unknown %s -o - | FileCheck %s --check-prefix=CHECK-EMULATION
; RUN: llc -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_bit_instructions %s -o - | FileCheck %s --check-prefix=CHECK-NATIVE
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-unknown-unknown %s -o - -filetype=obj | spirv-val %}
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_bit_instructions %s -o - -filetype=obj | spirv-val %}

; Without extension: should NOT use OpBitReverse
; CHECK-EMULATION-NOT: OpBitReverse
; CHECK-EMULATION-DAG: OpShiftRightLogical
; CHECK-EMULATION-DAG: OpShiftLeftLogical
; CHECK-EMULATION-DAG: OpBitwiseAnd
; CHECK-EMULATION-DAG: OpBitwiseOr

; With extension: should use OpBitReverse and declare the extension
; CHECK-NATIVE: OpExtension "SPV_KHR_bit_instructions"
; CHECK-NATIVE-DAG: OpBitReverse

target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-n8:16:32:64"
target triple = "spirv64-unknown-unknown"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Scalar types - 8, 16, 32, 64 bits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define spir_kernel void @test_scalar_i8(i8 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_scalar_i8
  ; CHECK-NATIVE-LABEL: test_scalar_i8
  ; CHECK-NATIVE: OpBitReverse
  %call = call i8 @llvm.bitreverse.i8(i8 %a)
  store i8 %call, ptr addrspace(1) %res, align 1
  ret void
}

define spir_kernel void @test_scalar_i16(i16 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_scalar_i16
  ; CHECK-NATIVE-LABEL: test_scalar_i16
  ; CHECK-NATIVE: OpBitReverse
  %call = call i16 @llvm.bitreverse.i16(i16 %a)
  store i16 %call, ptr addrspace(1) %res, align 2
  ret void
}

define spir_kernel void @test_scalar_i32(i32 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_scalar_i32
  ; CHECK-NATIVE-LABEL: test_scalar_i32
  ; CHECK-NATIVE: OpBitReverse
  %call = call i32 @llvm.bitreverse.i32(i32 %a)
  store i32 %call, ptr addrspace(1) %res, align 4
  ret void
}

define spir_kernel void @test_scalar_i64(i64 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_scalar_i64
  ; CHECK-NATIVE-LABEL: test_scalar_i64
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
  ; CHECK-EMULATION-LABEL: test_v2i8
  ; CHECK-NATIVE-LABEL: test_v2i8
  ; CHECK-NATIVE: OpBitReverse
  %call = call <2 x i8> @llvm.bitreverse.v2i8(<2 x i8> %a)
  store <2 x i8> %call, ptr addrspace(1) %res, align 2
  ret void
}

define spir_kernel void @test_v2i16(<2 x i16> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v2i16
  ; CHECK-NATIVE-LABEL: test_v2i16
  ; CHECK-NATIVE: OpBitReverse
  %call = call <2 x i16> @llvm.bitreverse.v2i16(<2 x i16> %a)
  store <2 x i16> %call, ptr addrspace(1) %res, align 4
  ret void
}

define spir_kernel void @test_v2i32(<2 x i32> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v2i32
  ; CHECK-NATIVE-LABEL: test_v2i32
  ; CHECK-NATIVE: OpBitReverse
  %call = call <2 x i32> @llvm.bitreverse.v2i32(<2 x i32> %a)
  store <2 x i32> %call, ptr addrspace(1) %res, align 8
  ret void
}

define spir_kernel void @test_v2i64(<2 x i64> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v2i64
  ; CHECK-NATIVE-LABEL: test_v2i64
  ; CHECK-NATIVE: OpBitReverse
  %call = call <2 x i64> @llvm.bitreverse.v2i64(<2 x i64> %a)
  store <2 x i64> %call, ptr addrspace(1) %res, align 16
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 3-element vectors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define spir_kernel void @test_v3i32(<3 x i32> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v3i32
  ; CHECK-NATIVE-LABEL: test_v3i32
  ; CHECK-NATIVE: OpBitReverse
  %call = call <3 x i32> @llvm.bitreverse.v3i32(<3 x i32> %a)
  store <3 x i32> %call, ptr addrspace(1) %res, align 16
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 4-element vectors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define spir_kernel void @test_v4i8(<4 x i8> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v4i8
  ; CHECK-NATIVE-LABEL: test_v4i8
  ; CHECK-NATIVE: OpBitReverse
  %call = call <4 x i8> @llvm.bitreverse.v4i8(<4 x i8> %a)
  store <4 x i8> %call, ptr addrspace(1) %res, align 4
  ret void
}

define spir_kernel void @test_v4i16(<4 x i16> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v4i16
  ; CHECK-NATIVE-LABEL: test_v4i16
  ; CHECK-NATIVE: OpBitReverse
  %call = call <4 x i16> @llvm.bitreverse.v4i16(<4 x i16> %a)
  store <4 x i16> %call, ptr addrspace(1) %res, align 8
  ret void
}

define spir_kernel void @test_v4i32(<4 x i32> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v4i32
  ; CHECK-NATIVE-LABEL: test_v4i32
  ; CHECK-NATIVE: OpBitReverse
  %call = call <4 x i32> @llvm.bitreverse.v4i32(<4 x i32> %a)
  store <4 x i32> %call, ptr addrspace(1) %res, align 16
  ret void
}

define spir_kernel void @test_v4i64(<4 x i64> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v4i64
  ; CHECK-NATIVE-LABEL: test_v4i64
  ; CHECK-NATIVE: OpBitReverse
  %call = call <4 x i64> @llvm.bitreverse.v4i64(<4 x i64> %a)
  store <4 x i64> %call, ptr addrspace(1) %res, align 32
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 8-element vectors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define spir_kernel void @test_v8i8(<8 x i8> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v8i8
  ; CHECK-NATIVE-LABEL: test_v8i8
  ; CHECK-NATIVE: OpBitReverse
  %call = call <8 x i8> @llvm.bitreverse.v8i8(<8 x i8> %a)
  store <8 x i8> %call, ptr addrspace(1) %res, align 8
  ret void
}

define spir_kernel void @test_v8i16(<8 x i16> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v8i16
  ; CHECK-NATIVE-LABEL: test_v8i16
  ; CHECK-NATIVE: OpBitReverse
  %call = call <8 x i16> @llvm.bitreverse.v8i16(<8 x i16> %a)
  store <8 x i16> %call, ptr addrspace(1) %res, align 16
  ret void
}

define spir_kernel void @test_v8i32(<8 x i32> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v8i32
  ; CHECK-NATIVE-LABEL: test_v8i32
  ; CHECK-NATIVE: OpBitReverse
  %call = call <8 x i32> @llvm.bitreverse.v8i32(<8 x i32> %a)
  store <8 x i32> %call, ptr addrspace(1) %res, align 32
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 16-element vectors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define spir_kernel void @test_v16i8(<16 x i8> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v16i8
  ; CHECK-NATIVE-LABEL: test_v16i8
  ; CHECK-NATIVE: OpBitReverse
  %call = call <16 x i8> @llvm.bitreverse.v16i8(<16 x i8> %a)
  store <16 x i8> %call, ptr addrspace(1) %res, align 16
  ret void
}

define spir_kernel void @test_v16i16(<16 x i16> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v16i16
  ; CHECK-NATIVE-LABEL: test_v16i16
  ; CHECK-NATIVE: OpBitReverse
  %call = call <16 x i16> @llvm.bitreverse.v16i16(<16 x i16> %a)
  store <16 x i16> %call, ptr addrspace(1) %res, align 32
  ret void
}

define spir_kernel void @test_v16i32(<16 x i32> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-EMULATION-LABEL: test_v16i32
  ; CHECK-NATIVE-LABEL: test_v16i32
  ; CHECK-NATIVE: OpBitReverse
  %call = call <16 x i32> @llvm.bitreverse.v16i32(<16 x i32> %a)
  store <16 x i32> %call, ptr addrspace(1) %res, align 64
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

; 3-element vectors
declare <3 x i32> @llvm.bitreverse.v3i32(<3 x i32>)

; 4-element vectors
declare <4 x i8>  @llvm.bitreverse.v4i8(<4 x i8>)
declare <4 x i16> @llvm.bitreverse.v4i16(<4 x i16>)
declare <4 x i32> @llvm.bitreverse.v4i32(<4 x i32>)
declare <4 x i64> @llvm.bitreverse.v4i64(<4 x i64>)

; 8-element vectors
declare <8 x i8>  @llvm.bitreverse.v8i8(<8 x i8>)
declare <8 x i16> @llvm.bitreverse.v8i16(<8 x i16>)
declare <8 x i32> @llvm.bitreverse.v8i32(<8 x i32>)

; 16-element vectors
declare <16 x i8>  @llvm.bitreverse.v16i8(<16 x i8>)
declare <16 x i16> @llvm.bitreverse.v16i16(<16 x i16>)
declare <16 x i32> @llvm.bitreverse.v16i32(<16 x i32>)

attributes #0 = { nounwind }
