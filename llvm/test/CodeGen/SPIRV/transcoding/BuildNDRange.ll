;; Test that checks all variants of ndrange and what ndrange_2D and ndrange_3D can coexist in the same module
;;
;;void test_ndrange_1D(size_t GS1 , size_t LS1 , size_t WO1) {
;;  ndrange_1D(GS1);
;;  ndrange_1D(GS1, LS1);
;;  ndrange_1D(WO1, GS1, LS1);
;;  // test const argument
;;  const size_t GS1c = 1;
;;  ndrange_1D(GS1c);
;;}
;;
;;void test_ndrange_2D(size_t GS2[2], size_t LS2[2], size_t WO2[2]) {
;;  ndrange_2D(GS2);
;;  ndrange_2D(GS2, LS2);
;;  ndrange_2D(WO2, GS2, LS2);
;;}
;;
;;void test_ndrange_3D(size_t GS3[3], size_t LS3[3], size_t WO3[3], size_t GS2[2]) {
;;  ndrange_3D(GS3);
;;  ndrange_3D(GS3, LS3);
;;  ndrange_3D(WO3, GS3, LS3);
;;  // test same argument
;;  ndrange_3D(GS3, GS3);
;;  ndrange_3D(GS3, GS3, GS3);
;;  // test const argument
;;  const size_t GS3c[3] = {1, 4, 7};
;;  ndrange_3D(GS3c);
;;  // test 2D and 3D can coexist in one funciton
;;  ndrange_2D(GS2);
;;}
;;
;; bash$ clang -cc1 -cl-std=CL2.0 -triple spirv64-unknown-unknown -emit-llvm -finclude-default-header -cl-single-precision-constant BuildNDRange.cl -o BuildNDRange.ll

; RUN: llc -O0 -verify-machineinstrs -mtriple=spirv64-unknown-unknown %s -o - | FileCheck %s
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-unknown-unknown %s -o - -filetype=obj | spirv-val %}

%struct.ndrange_t = type { i32, [3 x i64], [3 x i64], [3 x i64] }

@__const.test_ndrange_3D.GS3c = private unnamed_addr addrspace(2) constant [3 x i64] [i64 1, i64 4, i64 7], align 8

; CHECK: %[[#typeInt64:]] = OpTypeInt 64 0
; CHECK: %[[#typeInt32:]] = OpTypeInt 32 0
; CHECK: %[[#Num3:]] = OpConstant %[[#typeInt32]] 3
; CHECK: %[[#Array3x64:]] = OpTypeArray %[[#typeInt64:]] %[[#Num3]]
; CHECK: %[[#TypeNDRangeStruct:]] = OpTypeStruct %[[#typeInt32]] %[[#Array3x64]] %[[#Array3x64]] %[[#Array3x64]]
define spir_func void @test_ndrange_1D(i64 noundef %GS1, i64 noundef %LS1, i64 noundef %WO1) local_unnamed_addr #0 {
entry:
; CHECK-LABEL: Begin function test_ndrange_1D
; CHECK: %[[#ret1D_1:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS1D:]] %[[#Zero1D:]] %[[#Zero1D:]]
; CHECK: %[[#ret1D_2:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS1D]] %[[#LS1D:]] %[[#Zero1D]]
; CHECK: %[[#ret1D_3:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS1D]] %[[#LS1D]] %[[#GO1D:]]
; CHECK: %[[#ret1D_4:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS1Dc:]] %[[#Zero1D]] %[[#Zero1D]]
; CHECK: OpFunctionEnd
  %tmp = alloca %struct.ndrange_t, align 8
  %tmp1 = alloca %struct.ndrange_t, align 8
  %tmp2 = alloca %struct.ndrange_t, align 8
  %tmp3 = alloca %struct.ndrange_t, align 8
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp) #4
  call spir_func void @_Z10ndrange_1Dm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp, i64 noundef %GS1) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp1) #4
  call spir_func void @_Z10ndrange_1Dmm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp1, i64 noundef %GS1, i64 noundef %LS1) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp1) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp2) #4
  call spir_func void @_Z10ndrange_1Dmmm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp2, i64 noundef %WO1, i64 noundef %GS1, i64 noundef %LS1) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp2) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp3) #4
  call spir_func void @_Z10ndrange_1Dm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp3, i64 noundef 1) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp3) #4
  ret void
}

declare spir_func void @_Z10ndrange_1Dm(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, i64 noundef) local_unnamed_addr #1
declare spir_func void @_Z10ndrange_1Dmm(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, i64 noundef, i64 noundef) local_unnamed_addr #1
declare spir_func void @_Z10ndrange_1Dmmm(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, i64 noundef, i64 noundef, i64 noundef) local_unnamed_addr #1

define spir_func void @test_ndrange_2D(ptr noundef %GS2, ptr noundef %LS2, ptr noundef %WO2) local_unnamed_addr #0 {
entry:
; CHECK-LABEL: Begin function test_ndrange_2D
; CHECK: %[[#ret2D_1:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS2D_1:]] %[[#Zero2D:]] %[[#Zero2D:]]
; CHECK: %[[#ret2D_2:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS2D_2:]] %[[#LS2D_2:]] %[[#Zero2D]]
; CHECK: %[[#ret2D_3:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS2D_3:]] %[[#LS2D_3:]] %[[#GO2D_3:]]
  %tmp = alloca %struct.ndrange_t, align 8
  %tmp1 = alloca %struct.ndrange_t, align 8
  %tmp2 = alloca %struct.ndrange_t, align 8
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp) #4
  call spir_func void @_Z10ndrange_2DPKm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp, ptr noundef %GS2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp1) #4
  call spir_func void @_Z10ndrange_2DPKmS0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp1, ptr noundef %GS2, ptr noundef %LS2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp1) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp2) #4
  call spir_func void @_Z10ndrange_2DPKmS0_S0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp2, ptr noundef %WO2, ptr noundef %GS2, ptr noundef %LS2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp2) #4
  ret void
}

declare spir_func void @_Z10ndrange_2DPKm(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, ptr noundef) local_unnamed_addr #1
declare spir_func void @_Z10ndrange_2DPKmS0_(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, ptr noundef, ptr noundef) local_unnamed_addr #1
declare spir_func void @_Z10ndrange_2DPKmS0_S0_(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #1

define spir_func void @test_ndrange_3D(ptr noundef %GS3, ptr noundef %LS3, ptr noundef %WO3, ptr noundef %GS2) local_unnamed_addr #0 {
entry:
; CHECK-LABEL: Begin function test_ndrange_3D
; CHECK: %[[#ret3D_1:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS3D_1:]] %[[#Zero3D:]] %[[#Zero3D:]]
; CHECK: %[[#ret3D_2:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS3D_2:]] %[[#LS3D_2:]] %[[#Zero3D]]
; CHECK: %[[#ret3D_3:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS3D_3:]] %[[#LS3D_3:]] %[[#GO3D_3:]]
; CHECK: %[[#ret3D_4:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS3D_4:]] %[[#GS3D_4:]] %[[#Zero3D:]]
; CHECK: %[[#ret3D_5:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS3D_5:]] %[[#GS3D_5:]] %[[#GS3D_5:]]
; CHECK: %[[#ret3D_6:]] = OpBuildNDRange %[[#TypeNDRangeStruct]] %[[#GS2D_4:]] %[[#Zero2D]] %[[#Zero2D]]
  %tmp = alloca %struct.ndrange_t, align 8
  %tmp1 = alloca %struct.ndrange_t, align 8
  %tmp2 = alloca %struct.ndrange_t, align 8
  %tmp3 = alloca %struct.ndrange_t, align 8
  %tmp4 = alloca %struct.ndrange_t, align 8
  %GS3c = alloca [3 x i64], align 8
  %tmp5 = alloca %struct.ndrange_t, align 8
  %tmp6 = alloca %struct.ndrange_t, align 8
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp) #4
  call spir_func void @_Z10ndrange_3DPKm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp, ptr noundef %GS3) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp1) #4
  call spir_func void @_Z10ndrange_3DPKmS0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp1, ptr noundef %GS3, ptr noundef %LS3) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp1) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp2) #4
  call spir_func void @_Z10ndrange_3DPKmS0_S0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp2, ptr noundef %WO3, ptr noundef %GS3, ptr noundef %LS3) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp2) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp3) #4
  call spir_func void @_Z10ndrange_3DPKmS0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp3, ptr noundef %GS3, ptr noundef %GS3) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp3) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp4) #4
  call spir_func void @_Z10ndrange_3DPKmS0_S0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp4, ptr noundef %GS3, ptr noundef %GS3, ptr noundef %GS3) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp4) #4
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %GS3c) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(24) %GS3c, ptr addrspace(2) noundef align 8 dereferenceable(24) @__const.test_ndrange_3D.GS3c, i64 24, i1 false)
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp5) #4
  call spir_func void @_Z10ndrange_3DPKm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp5, ptr noundef nonnull %GS3c) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp5) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp6) #4
  call spir_func void @_Z10ndrange_2DPKm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp6, ptr noundef %GS2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp6) #4
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %GS3c) #4
  ret void
}

declare spir_func void @_Z10ndrange_3DPKm(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, ptr noundef) local_unnamed_addr #1
declare spir_func void @_Z10ndrange_3DPKmS0_(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, ptr noundef, ptr noundef) local_unnamed_addr #1
declare spir_func void @_Z10ndrange_3DPKmS0_S0_(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #1
