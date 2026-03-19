; RUN: llc -verify-machineinstrs -O0 -mtriple=spirv64-unknown-unknown %s -o - | FileCheck %s
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-unknown-unknown %s -o - -filetype=obj | spirv-val %}

%struct.ndrange_t = type { i32, [3 x i64], [3 x i64], [3 x i64] }

define spir_func void @test_ndrange_2D3D() local_unnamed_addr #0 {
; CHECK-LABEL: test_ndrange_2D3D
; CHECK:       Begin function test_ndrange_2D3D
; CHECK:       %[[#r18:]] = OpBuildNDRange %[[#r10:]] %[[#r11:]] %[[#r12:]] %[[#r13:]]
; CHECK-NOT:    OpStore %[[#r19:]] %[[#r18]]
entry:
  %tmp = alloca %struct.ndrange_t, align 8
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp) #3
  call spir_func %struct.ndrange_t @_Z10ndrange_1Dm(i64 noundef 1) #4
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp) #3
  ret void
}

declare spir_func %struct.ndrange_t  @_Z10ndrange_1Dm(i64 noundef) local_unnamed_addr #2
