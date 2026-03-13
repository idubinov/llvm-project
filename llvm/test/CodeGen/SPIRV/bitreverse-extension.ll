; Test bitreverse using OpBitReverse when SPV_KHR_bit_instructions extension IS available
; This test verifies that native OpBitReverse is used instead of emulation

; RUN: llc -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_bit_instructions %s -o - | FileCheck %s --check-prefix=CHECK-SPIRV
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_bit_instructions %s -o - -filetype=obj | spirv-val %}

; With SPV_KHR_bit_instructions enabled, we should use OpBitReverse
; CHECK-SPIRV: OpExtension "SPV_KHR_bit_instructions"
; CHECK-SPIRV-DAG: OpBitReverse

; We should NOT see emulation code (shifts and bitwise ops in the pattern used by emulation)
; The presence of a few shifts/bitwise ops is OK (for address calculation, etc.)
; but we should see OpBitReverse being used

target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-n8:16:32:64"
target triple = "spirv64-unknown-unknown"

; Function Attrs: nounwind
define spir_kernel void @test_bitreverse_scalar_i32(i32 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpFunction
  ; CHECK-SPIRV: OpBitReverse {{%[0-9]+}} {{%[0-9]+}}
  %call = call i32 @llvm.bitreverse.i32(i32 %a)
  store i32 %call, ptr addrspace(1) %res, align 4
  ret void
}

; Function Attrs: nounwind
define spir_kernel void @test_bitreverse_scalar_i64(i64 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpBitReverse {{%[0-9]+}} {{%[0-9]+}}
  %call = call i64 @llvm.bitreverse.i64(i64 %a)
  store i64 %call, ptr addrspace(1) %res, align 8
  ret void
}

; Function Attrs: nounwind
define spir_kernel void @test_bitreverse_scalar_i16(i16 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpBitReverse {{%[0-9]+}} {{%[0-9]+}}
  %call = call i16 @llvm.bitreverse.i16(i16 %a)
  store i16 %call, ptr addrspace(1) %res, align 2
  ret void
}

; Function Attrs: nounwind
define spir_kernel void @test_bitreverse_scalar_i8(i8 %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpBitReverse {{%[0-9]+}} {{%[0-9]+}}
  %call = call i8 @llvm.bitreverse.i8(i8 %a)
  store i8 %call, ptr addrspace(1) %res, align 1
  ret void
}

; Function Attrs: nounwind
define spir_kernel void @test_bitreverse_vector(<4 x i32> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpBitReverse {{%[0-9]+}} {{%[0-9]+}}
  %call = call <4 x i32> @llvm.bitreverse.v4i32(<4 x i32> %a)
  store <4 x i32> %call, ptr addrspace(1) %res, align 16
  ret void
}

; Function Attrs: nounwind
define spir_kernel void @test_bitreverse_v2i64(<2 x i64> %a, ptr addrspace(1) %res) #0 {
entry:
  ; CHECK-SPIRV: OpBitReverse {{%[0-9]+}} {{%[0-9]+}}
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

attributes #0 = { nounwind }
