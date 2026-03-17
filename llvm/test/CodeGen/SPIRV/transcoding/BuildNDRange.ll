;; Test that checks all variants of ndrange and what ndrange_1D, ndrange_2D and ndrange_3D can coexist in the same module
;;
;; bash$ cat BuildNDRange.cl
;; void test_ndrange_2D3D() {
;;   size_t GS1 = 1;
;;   size_t LS1 = 2;
;;   size_t WO1 = 3;
;;   ndrange_1D(GS1);
;;   ndrange_1D(GS1, LS1);
;;   ndrange_1D(WO1, GS1, LS1);
;;   ndrange_1D(GS1, GS1);
;;   ndrange_1D(GS1, GS1, GS1);
;;   size_t GS2[2] = {1, 1};
;;   size_t LS2[2] = {2, 2};
;;   size_t WO2[2] = {3, 3};
;;   ndrange_2D(GS2);
;;   ndrange_2D(GS2, LS2);
;;   ndrange_2D(WO2, GS2, LS2);
;;   ndrange_2D(GS2, GS2);
;;   ndrange_2D(GS2, GS2, GS2);
;;   size_t GS3[3] = {1, 1, 1};
;;   size_t LS3[3] = {1, 2, 1};
;;   size_t WO3[3] = {1, 3, 1};
;;   ndrange_3D(GS3);
;;   ndrange_2D(GS3, LS3);
;;   ndrange_2D(WO3, GS3, LS3);
;;   ndrange_2D(GS3, GS3);
;;   ndrange_2D(GS3, GS3, GS3);
;;   const size_t GS1c = 1;
;;   const size_t LS1c = 2;
;;   const size_t WO1c = 3;
;;   ndrange_1D(GS1c);
;;   ndrange_1D(GS1c, LS1c);
;;   ndrange_1D(WO1c, GS1c, LS1c);
;;   ndrange_1D(GS1c, GS1c);
;;   ndrange_1D(GS1c, GS1c, GS1c);
;;   const size_t GS2c[2] = {1, 1};
;;   const size_t LS2c[2] = {1, 2};
;;   const size_t WO2c[2] = {1, 3};
;;   ndrange_2D(GS2c);
;;   ndrange_2D(GS2c, LS2c);
;;   ndrange_2D(WO2c, GS2c, LS2c);
;;   ndrange_2D(GS2c, GS2c);
;;   ndrange_2D(GS2c, GS2c, GS2c);
;;   const size_t GS3c[3] = {1, 1, 1};
;;   const size_t LS3c[3] = {1, 1, 2};
;;   const size_t WO3c[3] = {1, 1, 3};
;;   ndrange_3D(GS3c);
;;   ndrange_2D(GS3c, LS3c);
;;   ndrange_2D(WO3c, GS3c, LS3c);
;;   ndrange_2D(GS3c, GS3c);
;;   ndrange_2D(GS3c, GS3c, GS3c);
;; }
;; bash$ clang -cc1  -cl-std=CL2.0 -triple spirv64-unknown-unknown -emit-llvm -finclude-default-header -cl-single-precision-constant BuildNDRange.cl -o BuildNDRange.ll


; RUN: llc -O0 -mtriple=spirv64-unknown-unknown %s -o - | FileCheck %s
; %if spirv-tools %{ llc -O0 -mtriple=spirv64-unknown-unknown %s -o - -filetype=obj | spirv-val %}

%struct.ndrange_t = type { i32, [3 x i64], [3 x i64], [3 x i64] }

@__const.test_ndrange_2D3D.GS2 = private unnamed_addr addrspace(2) constant [2 x i64] [i64 1, i64 1], align 8
@__const.test_ndrange_2D3D.LS2 = private unnamed_addr addrspace(2) constant [2 x i64] [i64 2, i64 2], align 8
@__const.test_ndrange_2D3D.WO2 = private unnamed_addr addrspace(2) constant [2 x i64] [i64 3, i64 3], align 8
@__const.test_ndrange_2D3D.GS3 = private unnamed_addr addrspace(2) constant [3 x i64] [i64 1, i64 1, i64 1], align 8
@__const.test_ndrange_2D3D.LS3 = private unnamed_addr addrspace(2) constant [3 x i64] [i64 1, i64 2, i64 1], align 8
@__const.test_ndrange_2D3D.WO3 = private unnamed_addr addrspace(2) constant [3 x i64] [i64 1, i64 3, i64 1], align 8
@__const.test_ndrange_2D3D.GS2c = private unnamed_addr addrspace(2) constant [2 x i64] [i64 1, i64 1], align 8
@__const.test_ndrange_2D3D.LS2c = private unnamed_addr addrspace(2) constant [2 x i64] [i64 1, i64 2], align 8
@__const.test_ndrange_2D3D.WO2c = private unnamed_addr addrspace(2) constant [2 x i64] [i64 1, i64 3], align 8
@__const.test_ndrange_2D3D.GS3c = private unnamed_addr addrspace(2) constant [3 x i64] [i64 1, i64 1, i64 1], align 8
@__const.test_ndrange_2D3D.LS3c = private unnamed_addr addrspace(2) constant [3 x i64] [i64 1, i64 1, i64 2], align 8
@__const.test_ndrange_2D3D.WO3c = private unnamed_addr addrspace(2) constant [3 x i64] [i64 1, i64 1, i64 3], align 8

define spir_func void @test_ndrange_2D3D() local_unnamed_addr #0 {
; CHECK-LABEL: test_ndrange_2D3D
; CHECK:       %[[#r50:]] = OpFunction %[[#r3:]] None %[[#r4:]] ; -- Begin function test_ndrange_2D3D
; CHECK-NEXT:    %[[#r2:]] = OpLabel
; CHECK-NEXT:    %[[#r51:]] = OpVariable %[[#r10:]] Function
; CHECK-NEXT:    %[[#r52:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r53:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r54:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r55:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r56:]] = OpVariable %[[#r13:]] Function
; CHECK-NEXT:    %[[#r57:]] = OpVariable %[[#r13]] Function
; CHECK-NEXT:    %[[#r58:]] = OpVariable %[[#r13]] Function
; CHECK-NEXT:    %[[#r59:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r60:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r61:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r62:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r63:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r64:]] = OpVariable %[[#r16:]] Function
; CHECK-NEXT:    %[[#r65:]] = OpVariable %[[#r16]] Function
; CHECK-NEXT:    %[[#r66:]] = OpVariable %[[#r16]] Function
; CHECK-NEXT:    %[[#r67:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r68:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r69:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r70:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r71:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r72:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r73:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r74:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r75:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r76:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r77:]] = OpVariable %[[#r13]] Function
; CHECK-NEXT:    %[[#r78:]] = OpVariable %[[#r13]] Function
; CHECK-NEXT:    %[[#r79:]] = OpVariable %[[#r13]] Function
; CHECK-NEXT:    %[[#r80:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r81:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r82:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r83:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r84:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r85:]] = OpVariable %[[#r16]] Function
; CHECK-NEXT:    %[[#r86:]] = OpVariable %[[#r16]] Function
; CHECK-NEXT:    %[[#r87:]] = OpVariable %[[#r16]] Function
; CHECK-NEXT:    %[[#r88:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r89:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r90:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r91:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r92:]] = OpVariable %[[#r10]] Function
; CHECK-NEXT:    %[[#r93:]] = OpBitcast %[[#r27:]] %[[#r51]]
; CHECK-NEXT:    OpLifetimeStart %[[#r93]] 80
; CHECK-NEXT:    %[[#r94:]] = OpBuildNDRange %[[#r9:]] %[[#r24:]] %[[#r25:]] %[[#r25:]]
; CHECK-NEXT:    OpStore %[[#r51]] %[[#r94]]
; CHECK-NEXT:    %[[#r95:]] = OpBitcast %[[#r27:]] %[[#r51]]
; CHECK-NEXT:    OpLifetimeStop %[[#r95]] 80
; CHECK-NEXT:    %[[#r96:]] = OpBitcast %[[#r27]] %[[#r52]]
; CHECK-NEXT:    OpLifetimeStart %[[#r96]] 80
; CHECK-NEXT:    %[[#r97:]] = OpBuildNDRange %[[#r9]] %[[#r24:]] %[[#r23:]] %[[#r25]]
; CHECK-NEXT:    OpStore %[[#r52]] %[[#r97]]
; CHECK-NEXT:    %[[#r98:]] = OpBitcast %[[#r27]] %[[#r52]]
; CHECK-NEXT:    OpLifetimeStop %[[#r98]] 80
; CHECK-NEXT:    %[[#r99:]] = OpBitcast %[[#r27]] %[[#r53]]
; CHECK-NEXT:    OpLifetimeStart %[[#r99]] 80
; CHECK-NEXT:    %[[#r100:]] = OpBuildNDRange %[[#r9]] %[[#r24]] %[[#r23:]] %[[#r22:]]
; CHECK-NEXT:    OpStore %[[#r53]] %[[#r100]]
; CHECK-NEXT:    %[[#r101:]] = OpBitcast %[[#r27]] %[[#r53]]
; CHECK-NEXT:    OpLifetimeStop %[[#r101]] 80
; CHECK-NEXT:    %[[#r102:]] = OpBitcast %[[#r27]] %[[#r54]]
; CHECK-NEXT:    OpLifetimeStart %[[#r102]] 80
; CHECK-NEXT:    %[[#r103:]] = OpBuildNDRange %[[#r9]] %[[#r24]] %[[#r24]] %[[#r25]]
; CHECK-NEXT:    OpStore %[[#r54]] %[[#r103]]
; CHECK-NEXT:    %[[#r104:]] = OpBitcast %[[#r27]] %[[#r54]]
; CHECK-NEXT:    OpLifetimeStop %[[#r104]] 80
; CHECK-NEXT:    %[[#r105:]] = OpBitcast %[[#r27]] %[[#r55]]
; CHECK-NEXT:    OpLifetimeStart %[[#r105]] 80
; CHECK-NEXT:    %[[#r106:]] = OpBuildNDRange %[[#r9]] %[[#r24]] %[[#r24]] %[[#r24]]
; CHECK-NEXT:    OpStore %[[#r55]] %[[#r106]]
; CHECK-NEXT:    %[[#r107:]] = OpBitcast %[[#r27]] %[[#r55]]
; CHECK-NEXT:    OpLifetimeStop %[[#r107]] 80
; CHECK-NEXT:    %[[#r108:]] = OpBitcast %[[#r27]] %[[#r56]]
; CHECK-NEXT:    OpLifetimeStart %[[#r108]] 16
; CHECK-NEXT:    OpCopyMemorySized %[[#r56]] %[[#r29:]] %[[#r21:]] Aligned 8
; CHECK-NEXT:    %[[#r109:]] = OpBitcast %[[#r27]] %[[#r57]]
; CHECK-NEXT:    OpLifetimeStart %[[#r109]] 16
; CHECK-NEXT:    OpCopyMemorySized %[[#r57]] %[[#r31:]] %[[#r21]] Aligned 8
; CHECK-NEXT:    %[[#r110:]] = OpBitcast %[[#r27]] %[[#r58]]
; CHECK-NEXT:    OpLifetimeStart %[[#r110]] 16
; CHECK-NEXT:    OpCopyMemorySized %[[#r58]] %[[#r33:]] %[[#r21]] Aligned 8
; CHECK-NEXT:    %[[#r111:]] = OpBitcast %[[#r27]] %[[#r59]]
; CHECK-NEXT:    OpLifetimeStart %[[#r111]] 80
; CHECK-NEXT:    %[[#r112:]] = OpLoad %[[#r12:]] %[[#r56]]
; CHECK-NEXT:    %[[#r113:]] = OpBuildNDRange %[[#r9]] %[[#r112]] %[[#r14:]] %[[#r14:]]
; CHECK-NEXT:    OpStore %[[#r59]] %[[#r113]]
; CHECK-NEXT:    %[[#r114:]] = OpBitcast %[[#r27]] %[[#r59]]
; CHECK-NEXT:    OpLifetimeStop %[[#r114]] 80
; CHECK-NEXT:    %[[#r115:]] = OpBitcast %[[#r27]] %[[#r60]]
; CHECK-NEXT:    OpLifetimeStart %[[#r115]] 80
; CHECK-NEXT:    %[[#r116:]] = OpBitcast %[[#r15:]] %[[#r56]]
; CHECK-NEXT:    %[[#r117:]] = OpBitcast %[[#r13]] %[[#r116]]
; CHECK-NEXT:    %[[#r118:]] = OpLoad %[[#r12]] %[[#r117]]
; CHECK-NEXT:    %[[#r119:]] = OpLoad %[[#r12]] %[[#r57]]
; CHECK-NEXT:    %[[#r120:]] = OpBuildNDRange %[[#r9]] %[[#r118]] %[[#r119]] %[[#r14]]
; CHECK-NEXT:    OpStore %[[#r60]] %[[#r120]]
; CHECK-NEXT:    %[[#r121:]] = OpBitcast %[[#r27]] %[[#r60]]
; CHECK-NEXT:    OpLifetimeStop %[[#r121]] 80
; CHECK-NEXT:    %[[#r122:]] = OpBitcast %[[#r27]] %[[#r61]]
; CHECK-NEXT:    OpLifetimeStart %[[#r122]] 80
; CHECK-NEXT:    %[[#r123:]] = OpBitcast %[[#r15]] %[[#r58]]
; CHECK-NEXT:    %[[#r124:]] = OpBitcast %[[#r13]] %[[#r116]]
; CHECK-NEXT:    %[[#r125:]] = OpLoad %[[#r12]] %[[#r124]]
; CHECK-NEXT:    %[[#r126:]] = OpLoad %[[#r12]] %[[#r57]]
; CHECK-NEXT:    %[[#r127:]] = OpBitcast %[[#r13]] %[[#r123]]
; CHECK-NEXT:    %[[#r128:]] = OpLoad %[[#r12]] %[[#r127]]
; CHECK-NEXT:    %[[#r129:]] = OpBuildNDRange %[[#r9]] %[[#r125]] %[[#r126]] %[[#r128]]
; CHECK-NEXT:    OpStore %[[#r61]] %[[#r129]]
; CHECK-NEXT:    %[[#r130:]] = OpBitcast %[[#r27]] %[[#r61]]
; CHECK-NEXT:    OpLifetimeStop %[[#r130]] 80
; CHECK-NEXT:    %[[#r131:]] = OpBitcast %[[#r27]] %[[#r62]]
; CHECK-NEXT:    OpLifetimeStart %[[#r131]] 80
; CHECK-NEXT:    %[[#r132:]] = OpBitcast %[[#r13]] %[[#r116]]
; CHECK-NEXT:    %[[#r133:]] = OpLoad %[[#r12]] %[[#r132]]
; CHECK-NEXT:    %[[#r134:]] = OpLoad %[[#r12]] %[[#r56]]
; CHECK-NEXT:    %[[#r135:]] = OpBuildNDRange %[[#r9]] %[[#r133]] %[[#r134]] %[[#r14]]
; CHECK-NEXT:    OpStore %[[#r62]] %[[#r135]]
; CHECK-NEXT:    %[[#r136:]] = OpBitcast %[[#r27]] %[[#r62]]
; CHECK-NEXT:    OpLifetimeStop %[[#r136]] 80
; CHECK-NEXT:    %[[#r137:]] = OpBitcast %[[#r27]] %[[#r63]]
; CHECK-NEXT:    OpLifetimeStart %[[#r137]] 80
; CHECK-NEXT:    %[[#r138:]] = OpBitcast %[[#r13]] %[[#r116]]
; CHECK-NEXT:    %[[#r139:]] = OpLoad %[[#r12]] %[[#r138]]
; CHECK-NEXT:    %[[#r140:]] = OpLoad %[[#r12]] %[[#r56]]
; CHECK-NEXT:    %[[#r141:]] = OpBitcast %[[#r13]] %[[#r116]]
; CHECK-NEXT:    %[[#r142:]] = OpLoad %[[#r12]] %[[#r141]]
; CHECK-NEXT:    %[[#r143:]] = OpBuildNDRange %[[#r9]] %[[#r139]] %[[#r140]] %[[#r142]]
; CHECK-NEXT:    OpStore %[[#r63]] %[[#r143]]
; CHECK-NEXT:    %[[#r144:]] = OpBitcast %[[#r27]] %[[#r63]]
; CHECK-NEXT:    OpLifetimeStop %[[#r144]] 80
; CHECK-NEXT:    %[[#r145:]] = OpBitcast %[[#r27]] %[[#r64]]
; CHECK-NEXT:    OpLifetimeStart %[[#r145]] 24
; CHECK-NEXT:    OpCopyMemorySized %[[#r64]] %[[#r35:]] %[[#r20:]] Aligned 8
; CHECK-NEXT:    %[[#r146:]] = OpBitcast %[[#r27]] %[[#r65]]
; CHECK-NEXT:    OpLifetimeStart %[[#r146]] 24
; CHECK-NEXT:    OpCopyMemorySized %[[#r65]] %[[#r37:]] %[[#r20]] Aligned 8
; CHECK-NEXT:    %[[#r147:]] = OpBitcast %[[#r27]] %[[#r66]]
; CHECK-NEXT:    OpLifetimeStart %[[#r147]] 24
; CHECK-NEXT:    OpCopyMemorySized %[[#r66]] %[[#r39:]] %[[#r20]] Aligned 8
; CHECK-NEXT:    %[[#r148:]] = OpBitcast %[[#r27]] %[[#r67]]
; CHECK-NEXT:    OpLifetimeStart %[[#r148]] 80
; CHECK-NEXT:    %[[#r149:]] = OpLoad %[[#r8:]] %[[#r64]]
; CHECK-NEXT:    %[[#r150:]] = OpBuildNDRange %[[#r9]] %[[#r149]] %[[#r17:]] %[[#r17:]]
; CHECK-NEXT:    OpStore %[[#r67]] %[[#r150]]
; CHECK-NEXT:    %[[#r151:]] = OpBitcast %[[#r27]] %[[#r67]]
; CHECK-NEXT:    OpLifetimeStop %[[#r151]] 80
; CHECK-NEXT:    %[[#r152:]] = OpBitcast %[[#r27]] %[[#r68]]
; CHECK-NEXT:    OpLifetimeStart %[[#r152]] 80
; CHECK-NEXT:    %[[#r153:]] = OpBitcast %[[#r15]] %[[#r64]]
; CHECK-NEXT:    %[[#r154:]] = OpBitcast %[[#r13]] %[[#r153]]
; CHECK-NEXT:    %[[#r155:]] = OpLoad %[[#r12]] %[[#r154]]
; CHECK-NEXT:    %[[#r156:]] = OpBitcast %[[#r13]] %[[#r65]]
; CHECK-NEXT:    %[[#r157:]] = OpLoad %[[#r12]] %[[#r156]]
; CHECK-NEXT:    %[[#r158:]] = OpBuildNDRange %[[#r9]] %[[#r155]] %[[#r157]] %[[#r14]]
; CHECK-NEXT:    OpStore %[[#r68]] %[[#r158]]
; CHECK-NEXT:    %[[#r159:]] = OpBitcast %[[#r27]] %[[#r68]]
; CHECK-NEXT:    OpLifetimeStop %[[#r159]] 80
; CHECK-NEXT:    %[[#r160:]] = OpBitcast %[[#r27]] %[[#r69]]
; CHECK-NEXT:    OpLifetimeStart %[[#r160]] 80
; CHECK-NEXT:    %[[#r161:]] = OpBitcast %[[#r15]] %[[#r66]]
; CHECK-NEXT:    %[[#r162:]] = OpBitcast %[[#r13]] %[[#r153]]
; CHECK-NEXT:    %[[#r163:]] = OpLoad %[[#r12]] %[[#r162]]
; CHECK-NEXT:    %[[#r164:]] = OpBitcast %[[#r13]] %[[#r65]]
; CHECK-NEXT:    %[[#r165:]] = OpLoad %[[#r12]] %[[#r164]]
; CHECK-NEXT:    %[[#r166:]] = OpBitcast %[[#r13]] %[[#r161]]
; CHECK-NEXT:    %[[#r167:]] = OpLoad %[[#r12]] %[[#r166]]
; CHECK-NEXT:    %[[#r168:]] = OpBuildNDRange %[[#r9]] %[[#r163]] %[[#r165]] %[[#r167]]
; CHECK-NEXT:    OpStore %[[#r69]] %[[#r168]]
; CHECK-NEXT:    %[[#r169:]] = OpBitcast %[[#r27]] %[[#r69]]
; CHECK-NEXT:    OpLifetimeStop %[[#r169]] 80
; CHECK-NEXT:    %[[#r170:]] = OpBitcast %[[#r27]] %[[#r70]]
; CHECK-NEXT:    OpLifetimeStart %[[#r170]] 80
; CHECK-NEXT:    %[[#r171:]] = OpBitcast %[[#r13]] %[[#r153]]
; CHECK-NEXT:    %[[#r172:]] = OpLoad %[[#r12]] %[[#r171]]
; CHECK-NEXT:    %[[#r173:]] = OpBitcast %[[#r13]] %[[#r64]]
; CHECK-NEXT:    %[[#r174:]] = OpLoad %[[#r12]] %[[#r173]]
; CHECK-NEXT:    %[[#r175:]] = OpBuildNDRange %[[#r9]] %[[#r172]] %[[#r174]] %[[#r14]]
; CHECK-NEXT:    OpStore %[[#r70]] %[[#r175]]
; CHECK-NEXT:    %[[#r176:]] = OpBitcast %[[#r27]] %[[#r70]]
; CHECK-NEXT:    OpLifetimeStop %[[#r176]] 80
; CHECK-NEXT:    %[[#r177:]] = OpBitcast %[[#r27]] %[[#r71]]
; CHECK-NEXT:    OpLifetimeStart %[[#r177]] 80
; CHECK-NEXT:    %[[#r178:]] = OpBitcast %[[#r13]] %[[#r153]]
; CHECK-NEXT:    %[[#r179:]] = OpLoad %[[#r12]] %[[#r178]]
; CHECK-NEXT:    %[[#r180:]] = OpBitcast %[[#r13]] %[[#r64]]
; CHECK-NEXT:    %[[#r181:]] = OpLoad %[[#r12]] %[[#r180]]
; CHECK-NEXT:    %[[#r182:]] = OpBitcast %[[#r13]] %[[#r153]]
; CHECK-NEXT:    %[[#r183:]] = OpLoad %[[#r12]] %[[#r182]]
; CHECK-NEXT:    %[[#r184:]] = OpBuildNDRange %[[#r9]] %[[#r179]] %[[#r181]] %[[#r183]]
; CHECK-NEXT:    OpStore %[[#r71]] %[[#r184]]
; CHECK-NEXT:    %[[#r185:]] = OpBitcast %[[#r27]] %[[#r71]]
; CHECK-NEXT:    OpLifetimeStop %[[#r185]] 80
; CHECK-NEXT:    %[[#r186:]] = OpBitcast %[[#r27]] %[[#r72]]
; CHECK-NEXT:    OpLifetimeStart %[[#r186]] 80
; CHECK-NEXT:    %[[#r187:]] = OpBuildNDRange %[[#r9]] %[[#r24]] %[[#r25]] %[[#r25]]
; CHECK-NEXT:    OpStore %[[#r72]] %[[#r187]]
; CHECK-NEXT:    %[[#r188:]] = OpBitcast %[[#r27]] %[[#r72]]
; CHECK-NEXT:    OpLifetimeStop %[[#r188]] 80
; CHECK-NEXT:    %[[#r189:]] = OpBitcast %[[#r27]] %[[#r73]]
; CHECK-NEXT:    OpLifetimeStart %[[#r189]] 80
; CHECK-NEXT:    %[[#r190:]] = OpBuildNDRange %[[#r9]] %[[#r24]] %[[#r23]] %[[#r25]]
; CHECK-NEXT:    OpStore %[[#r73]] %[[#r190]]
; CHECK-NEXT:    %[[#r191:]] = OpBitcast %[[#r27]] %[[#r73]]
; CHECK-NEXT:    OpLifetimeStop %[[#r191]] 80
; CHECK-NEXT:    %[[#r192:]] = OpBitcast %[[#r27]] %[[#r74]]
; CHECK-NEXT:    OpLifetimeStart %[[#r192]] 80
; CHECK-NEXT:    %[[#r193:]] = OpBuildNDRange %[[#r9]] %[[#r24]] %[[#r23]] %[[#r22]]
; CHECK-NEXT:    OpStore %[[#r74]] %[[#r193]]
; CHECK-NEXT:    %[[#r194:]] = OpBitcast %[[#r27]] %[[#r74]]
; CHECK-NEXT:    OpLifetimeStop %[[#r194]] 80
; CHECK-NEXT:    %[[#r195:]] = OpBitcast %[[#r27]] %[[#r75]]
; CHECK-NEXT:    OpLifetimeStart %[[#r195]] 80
; CHECK-NEXT:    %[[#r196:]] = OpBuildNDRange %[[#r9]] %[[#r24]] %[[#r24]] %[[#r25]]
; CHECK-NEXT:    OpStore %[[#r75]] %[[#r196]]
; CHECK-NEXT:    %[[#r197:]] = OpBitcast %[[#r27]] %[[#r75]]
; CHECK-NEXT:    OpLifetimeStop %[[#r197]] 80
; CHECK-NEXT:    %[[#r198:]] = OpBitcast %[[#r27]] %[[#r76]]
; CHECK-NEXT:    OpLifetimeStart %[[#r198]] 80
; CHECK-NEXT:    %[[#r199:]] = OpBuildNDRange %[[#r9]] %[[#r24]] %[[#r24]] %[[#r24]]
; CHECK-NEXT:    OpStore %[[#r76]] %[[#r199]]
; CHECK-NEXT:    %[[#r200:]] = OpBitcast %[[#r27]] %[[#r76]]
; CHECK-NEXT:    OpLifetimeStop %[[#r200]] 80
; CHECK-NEXT:    %[[#r201:]] = OpBitcast %[[#r27]] %[[#r77]]
; CHECK-NEXT:    OpLifetimeStart %[[#r201]] 16
; CHECK-NEXT:    OpCopyMemorySized %[[#r77]] %[[#r40:]] %[[#r21:]] Aligned 8
; CHECK-NEXT:    %[[#r202:]] = OpBitcast %[[#r27]] %[[#r78]]
; CHECK-NEXT:    OpLifetimeStart %[[#r202]] 16
; CHECK-NEXT:    OpCopyMemorySized %[[#r78]] %[[#r42:]] %[[#r21]] Aligned 8
; CHECK-NEXT:    %[[#r203:]] = OpBitcast %[[#r27]] %[[#r79]]
; CHECK-NEXT:    OpLifetimeStart %[[#r203]] 16
; CHECK-NEXT:    OpCopyMemorySized %[[#r79]] %[[#r44:]] %[[#r21]] Aligned 8
; CHECK-NEXT:    %[[#r204:]] = OpBitcast %[[#r27]] %[[#r80]]
; CHECK-NEXT:    OpLifetimeStart %[[#r204]] 80
; CHECK-NEXT:    %[[#r205:]] = OpLoad %[[#r12]] %[[#r77]]
; CHECK-NEXT:    %[[#r206:]] = OpBuildNDRange %[[#r9]] %[[#r205]] %[[#r14]] %[[#r14]]
; CHECK-NEXT:    OpStore %[[#r80]] %[[#r206]]
; CHECK-NEXT:    %[[#r207:]] = OpBitcast %[[#r27]] %[[#r80]]
; CHECK-NEXT:    OpLifetimeStop %[[#r207]] 80
; CHECK-NEXT:    %[[#r208:]] = OpBitcast %[[#r27]] %[[#r81]]
; CHECK-NEXT:    OpLifetimeStart %[[#r208]] 80
; CHECK-NEXT:    %[[#r209:]] = OpBitcast %[[#r15]] %[[#r77]]
; CHECK-NEXT:    %[[#r210:]] = OpBitcast %[[#r13]] %[[#r209]]
; CHECK-NEXT:    %[[#r211:]] = OpLoad %[[#r12]] %[[#r210]]
; CHECK-NEXT:    %[[#r212:]] = OpLoad %[[#r12]] %[[#r78]]
; CHECK-NEXT:    %[[#r213:]] = OpBuildNDRange %[[#r9]] %[[#r211]] %[[#r212]] %[[#r14]]
; CHECK-NEXT:    OpStore %[[#r81]] %[[#r213]]
; CHECK-NEXT:    %[[#r214:]] = OpBitcast %[[#r27]] %[[#r81]]
; CHECK-NEXT:    OpLifetimeStop %[[#r214]] 80
; CHECK-NEXT:    %[[#r215:]] = OpBitcast %[[#r27]] %[[#r82]]
; CHECK-NEXT:    OpLifetimeStart %[[#r215]] 80
; CHECK-NEXT:    %[[#r216:]] = OpBitcast %[[#r15]] %[[#r79]]
; CHECK-NEXT:    %[[#r217:]] = OpBitcast %[[#r13]] %[[#r209]]
; CHECK-NEXT:    %[[#r218:]] = OpLoad %[[#r12]] %[[#r217]]
; CHECK-NEXT:    %[[#r219:]] = OpLoad %[[#r12]] %[[#r78]]
; CHECK-NEXT:    %[[#r220:]] = OpBitcast %[[#r13]] %[[#r216]]
; CHECK-NEXT:    %[[#r221:]] = OpLoad %[[#r12]] %[[#r220]]
; CHECK-NEXT:    %[[#r222:]] = OpBuildNDRange %[[#r9]] %[[#r218]] %[[#r219]] %[[#r221]]
; CHECK-NEXT:    OpStore %[[#r82]] %[[#r222]]
; CHECK-NEXT:    %[[#r223:]] = OpBitcast %[[#r27]] %[[#r82]]
; CHECK-NEXT:    OpLifetimeStop %[[#r223]] 80
; CHECK-NEXT:    %[[#r224:]] = OpBitcast %[[#r27]] %[[#r83]]
; CHECK-NEXT:    OpLifetimeStart %[[#r224]] 80
; CHECK-NEXT:    %[[#r225:]] = OpBitcast %[[#r13]] %[[#r209]]
; CHECK-NEXT:    %[[#r226:]] = OpLoad %[[#r12]] %[[#r225]]
; CHECK-NEXT:    %[[#r227:]] = OpLoad %[[#r12]] %[[#r77]]
; CHECK-NEXT:    %[[#r228:]] = OpBuildNDRange %[[#r9]] %[[#r226]] %[[#r227]] %[[#r14]]
; CHECK-NEXT:    OpStore %[[#r83]] %[[#r228]]
; CHECK-NEXT:    %[[#r229:]] = OpBitcast %[[#r27]] %[[#r83]]
; CHECK-NEXT:    OpLifetimeStop %[[#r229]] 80
; CHECK-NEXT:    %[[#r230:]] = OpBitcast %[[#r27]] %[[#r84]]
; CHECK-NEXT:    OpLifetimeStart %[[#r230]] 80
; CHECK-NEXT:    %[[#r231:]] = OpBitcast %[[#r13]] %[[#r209]]
; CHECK-NEXT:    %[[#r232:]] = OpLoad %[[#r12]] %[[#r231]]
; CHECK-NEXT:    %[[#r233:]] = OpLoad %[[#r12]] %[[#r77]]
; CHECK-NEXT:    %[[#r234:]] = OpBitcast %[[#r13]] %[[#r209]]
; CHECK-NEXT:    %[[#r235:]] = OpLoad %[[#r12]] %[[#r234]]
; CHECK-NEXT:    %[[#r236:]] = OpBuildNDRange %[[#r9]] %[[#r232]] %[[#r233]] %[[#r235]]
; CHECK-NEXT:    OpStore %[[#r84]] %[[#r236]]
; CHECK-NEXT:    %[[#r237:]] = OpBitcast %[[#r27]] %[[#r84]]
; CHECK-NEXT:    OpLifetimeStop %[[#r237]] 80
; CHECK-NEXT:    %[[#r238:]] = OpBitcast %[[#r27]] %[[#r85]]
; CHECK-NEXT:    OpLifetimeStart %[[#r238]] 24
; CHECK-NEXT:    OpCopyMemorySized %[[#r85]] %[[#r45:]] %[[#r20]] Aligned 8
; CHECK-NEXT:    %[[#r239:]] = OpBitcast %[[#r27]] %[[#r86]]
; CHECK-NEXT:    OpLifetimeStart %[[#r239]] 24
; CHECK-NEXT:    OpCopyMemorySized %[[#r86]] %[[#r47:]] %[[#r20]] Aligned 8
; CHECK-NEXT:    %[[#r240:]] = OpBitcast %[[#r27]] %[[#r87]]
; CHECK-NEXT:    OpLifetimeStart %[[#r240]] 24
; CHECK-NEXT:    OpCopyMemorySized %[[#r87]] %[[#r49:]] %[[#r20]] Aligned 8
; CHECK-NEXT:    %[[#r241:]] = OpBitcast %[[#r27]] %[[#r88]]
; CHECK-NEXT:    OpLifetimeStart %[[#r241]] 80
; CHECK-NEXT:    %[[#r242:]] = OpLoad %[[#r8]] %[[#r85]]
; CHECK-NEXT:    %[[#r243:]] = OpBuildNDRange %[[#r9]] %[[#r242]] %[[#r17]] %[[#r17]]
; CHECK-NEXT:    OpStore %[[#r88]] %[[#r243]]
; CHECK-NEXT:    %[[#r244:]] = OpBitcast %[[#r27]] %[[#r88]]
; CHECK-NEXT:    OpLifetimeStop %[[#r244]] 80
; CHECK-NEXT:    %[[#r245:]] = OpBitcast %[[#r27]] %[[#r89]]
; CHECK-NEXT:    OpLifetimeStart %[[#r245]] 80
; CHECK-NEXT:    %[[#r246:]] = OpBitcast %[[#r15]] %[[#r85]]
; CHECK-NEXT:    %[[#r247:]] = OpBitcast %[[#r13]] %[[#r246]]
; CHECK-NEXT:    %[[#r248:]] = OpLoad %[[#r12]] %[[#r247]]
; CHECK-NEXT:    %[[#r249:]] = OpBitcast %[[#r13]] %[[#r86]]
; CHECK-NEXT:    %[[#r250:]] = OpLoad %[[#r12]] %[[#r249]]
; CHECK-NEXT:    %[[#r251:]] = OpBuildNDRange %[[#r9]] %[[#r248]] %[[#r250]] %[[#r14]]
; CHECK-NEXT:    OpStore %[[#r89]] %[[#r251]]
; CHECK-NEXT:    %[[#r252:]] = OpBitcast %[[#r27]] %[[#r89]]
; CHECK-NEXT:    OpLifetimeStop %[[#r252]] 80
; CHECK-NEXT:    %[[#r253:]] = OpBitcast %[[#r27]] %[[#r90]]
; CHECK-NEXT:    OpLifetimeStart %[[#r253]] 80
; CHECK-NEXT:    %[[#r254:]] = OpBitcast %[[#r15]] %[[#r87]]
; CHECK-NEXT:    %[[#r255:]] = OpBitcast %[[#r13]] %[[#r246]]
; CHECK-NEXT:    %[[#r256:]] = OpLoad %[[#r12]] %[[#r255]]
; CHECK-NEXT:    %[[#r257:]] = OpBitcast %[[#r13]] %[[#r86]]
; CHECK-NEXT:    %[[#r258:]] = OpLoad %[[#r12]] %[[#r257]]
; CHECK-NEXT:    %[[#r259:]] = OpBitcast %[[#r13]] %[[#r254]]
; CHECK-NEXT:    %[[#r260:]] = OpLoad %[[#r12]] %[[#r259]]
; CHECK-NEXT:    %[[#r261:]] = OpBuildNDRange %[[#r9]] %[[#r256]] %[[#r258]] %[[#r260]]
; CHECK-NEXT:    OpStore %[[#r90]] %[[#r261]]
; CHECK-NEXT:    %[[#r262:]] = OpBitcast %[[#r27]] %[[#r90]]
; CHECK-NEXT:    OpLifetimeStop %[[#r262]] 80
; CHECK-NEXT:    %[[#r263:]] = OpBitcast %[[#r27]] %[[#r91]]
; CHECK-NEXT:    OpLifetimeStart %[[#r263]] 80
; CHECK-NEXT:    %[[#r264:]] = OpBitcast %[[#r13]] %[[#r246]]
; CHECK-NEXT:    %[[#r265:]] = OpLoad %[[#r12]] %[[#r264]]
; CHECK-NEXT:    %[[#r266:]] = OpBitcast %[[#r13]] %[[#r85]]
; CHECK-NEXT:    %[[#r267:]] = OpLoad %[[#r12]] %[[#r266]]
; CHECK-NEXT:    %[[#r268:]] = OpBuildNDRange %[[#r9]] %[[#r265]] %[[#r267]] %[[#r14]]
; CHECK-NEXT:    OpStore %[[#r91]] %[[#r268]]
; CHECK-NEXT:    %[[#r269:]] = OpBitcast %[[#r27]] %[[#r91]]
; CHECK-NEXT:    OpLifetimeStop %[[#r269]] 80
; CHECK-NEXT:    %[[#r270:]] = OpBitcast %[[#r27]] %[[#r92]]
; CHECK-NEXT:    OpLifetimeStart %[[#r270]] 80
; CHECK-NEXT:    %[[#r271:]] = OpBitcast %[[#r13]] %[[#r246]]
; CHECK-NEXT:    %[[#r272:]] = OpLoad %[[#r12]] %[[#r271]]
; CHECK-NEXT:    %[[#r273:]] = OpBitcast %[[#r13]] %[[#r85]]
; CHECK-NEXT:    %[[#r274:]] = OpLoad %[[#r12]] %[[#r273]]
; CHECK-NEXT:    %[[#r275:]] = OpBitcast %[[#r13]] %[[#r246]]
; CHECK-NEXT:    %[[#r276:]] = OpLoad %[[#r12]] %[[#r275]]
; CHECK-NEXT:    %[[#r277:]] = OpBuildNDRange %[[#r9]] %[[#r272]] %[[#r274]] %[[#r276]]
; CHECK-NEXT:    OpStore %[[#r92]] %[[#r277]]
; CHECK-NEXT:    %[[#r278:]] = OpBitcast %[[#r27]] %[[#r92]]
; CHECK-NEXT:    OpLifetimeStop %[[#r278]] 80
; CHECK-NEXT:    %[[#r279:]] = OpBitcast %[[#r27]] %[[#r87]]
; CHECK-NEXT:    OpLifetimeStop %[[#r279]] 24
; CHECK-NEXT:    %[[#r280:]] = OpBitcast %[[#r27]] %[[#r86]]
; CHECK-NEXT:    OpLifetimeStop %[[#r280]] 24
; CHECK-NEXT:    %[[#r281:]] = OpBitcast %[[#r27]] %[[#r85]]
; CHECK-NEXT:    OpLifetimeStop %[[#r281]] 24
; CHECK-NEXT:    %[[#r282:]] = OpBitcast %[[#r27]] %[[#r79]]
; CHECK-NEXT:    OpLifetimeStop %[[#r282]] 16
; CHECK-NEXT:    %[[#r283:]] = OpBitcast %[[#r27]] %[[#r78]]
; CHECK-NEXT:    OpLifetimeStop %[[#r283]] 16
; CHECK-NEXT:    %[[#r284:]] = OpBitcast %[[#r27]] %[[#r77]]
; CHECK-NEXT:    OpLifetimeStop %[[#r284]] 16
; CHECK-NEXT:    %[[#r285:]] = OpBitcast %[[#r27]] %[[#r66]]
; CHECK-NEXT:    OpLifetimeStop %[[#r285]] 24
; CHECK-NEXT:    %[[#r286:]] = OpBitcast %[[#r27]] %[[#r65]]
; CHECK-NEXT:    OpLifetimeStop %[[#r286]] 24
; CHECK-NEXT:    %[[#r287:]] = OpBitcast %[[#r27]] %[[#r64]]
; CHECK-NEXT:    OpLifetimeStop %[[#r287]] 24
; CHECK-NEXT:    %[[#r288:]] = OpBitcast %[[#r27]] %[[#r58]]
; CHECK-NEXT:    OpLifetimeStop %[[#r288]] 16
; CHECK-NEXT:    %[[#r289:]] = OpBitcast %[[#r27]] %[[#r57]]
; CHECK-NEXT:    OpLifetimeStop %[[#r289]] 16
; CHECK-NEXT:    %[[#r290:]] = OpBitcast %[[#r27]] %[[#r56]]
; CHECK-NEXT:    OpLifetimeStop %[[#r290]] 16
; CHECK-NEXT:    OpReturn
; CHECK-NEXT:    OpFunctionEnd
entry:
  %tmp = alloca %struct.ndrange_t, align 8
  %tmp1 = alloca %struct.ndrange_t, align 8
  %tmp2 = alloca %struct.ndrange_t, align 8
  %tmp3 = alloca %struct.ndrange_t, align 8
  %tmp4 = alloca %struct.ndrange_t, align 8
  %GS2 = alloca [2 x i64], align 8
  %LS2 = alloca [2 x i64], align 8
  %WO2 = alloca [2 x i64], align 8
  %tmp5 = alloca %struct.ndrange_t, align 8
  %tmp8 = alloca %struct.ndrange_t, align 8
  %tmp12 = alloca %struct.ndrange_t, align 8
  %tmp15 = alloca %struct.ndrange_t, align 8
  %tmp19 = alloca %struct.ndrange_t, align 8
  %GS3 = alloca [3 x i64], align 8
  %LS3 = alloca [3 x i64], align 8
  %WO3 = alloca [3 x i64], align 8
  %tmp21 = alloca %struct.ndrange_t, align 8
  %tmp24 = alloca %struct.ndrange_t, align 8
  %tmp28 = alloca %struct.ndrange_t, align 8
  %tmp31 = alloca %struct.ndrange_t, align 8
  %tmp35 = alloca %struct.ndrange_t, align 8
  %tmp36 = alloca %struct.ndrange_t, align 8
  %tmp37 = alloca %struct.ndrange_t, align 8
  %tmp38 = alloca %struct.ndrange_t, align 8
  %tmp39 = alloca %struct.ndrange_t, align 8
  %tmp40 = alloca %struct.ndrange_t, align 8
  %GS2c = alloca [2 x i64], align 8
  %LS2c = alloca [2 x i64], align 8
  %WO2c = alloca [2 x i64], align 8
  %tmp42 = alloca %struct.ndrange_t, align 8
  %tmp45 = alloca %struct.ndrange_t, align 8
  %tmp49 = alloca %struct.ndrange_t, align 8
  %tmp52 = alloca %struct.ndrange_t, align 8
  %tmp56 = alloca %struct.ndrange_t, align 8
  %GS3c = alloca [3 x i64], align 8
  %LS3c = alloca [3 x i64], align 8
  %WO3c = alloca [3 x i64], align 8
  %tmp58 = alloca %struct.ndrange_t, align 8
  %tmp61 = alloca %struct.ndrange_t, align 8
  %tmp65 = alloca %struct.ndrange_t, align 8
  %tmp68 = alloca %struct.ndrange_t, align 8
  %tmp72 = alloca %struct.ndrange_t, align 8
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp) #4
  call spir_func void @_Z10ndrange_1Dm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp, i64 noundef 1) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp1) #4
  call spir_func void @_Z10ndrange_1Dmm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp1, i64 noundef 1, i64 noundef 2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp1) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp2) #4
  call spir_func void @_Z10ndrange_1Dmmm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp2, i64 noundef 3, i64 noundef 1, i64 noundef 2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp2) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp3) #4
  call spir_func void @_Z10ndrange_1Dmm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp3, i64 noundef 1, i64 noundef 1) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp3) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp4) #4
  call spir_func void @_Z10ndrange_1Dmmm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp4, i64 noundef 1, i64 noundef 1, i64 noundef 1) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp4) #4
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %GS2) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(16) %GS2, ptr addrspace(2) noundef align 8 dereferenceable(16) @__const.test_ndrange_2D3D.GS2, i64 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %LS2) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(16) %LS2, ptr addrspace(2) noundef align 8 dereferenceable(16) @__const.test_ndrange_2D3D.LS2, i64 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %WO2) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(16) %WO2, ptr addrspace(2) noundef align 8 dereferenceable(16) @__const.test_ndrange_2D3D.WO2, i64 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp5) #4
  call spir_func void @_Z10ndrange_2DPKm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp5, ptr noundef nonnull %GS2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp5) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp8) #4
  call spir_func void @_Z10ndrange_2DPKmS0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp8, ptr noundef nonnull %GS2, ptr noundef nonnull %LS2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp8) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp12) #4
  call spir_func void @_Z10ndrange_2DPKmS0_S0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp12, ptr noundef nonnull %WO2, ptr noundef nonnull %GS2, ptr noundef nonnull %LS2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp12) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp15) #4
  call spir_func void @_Z10ndrange_2DPKmS0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp15, ptr noundef nonnull %GS2, ptr noundef nonnull %GS2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp15) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp19) #4
  call spir_func void @_Z10ndrange_2DPKmS0_S0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp19, ptr noundef nonnull %GS2, ptr noundef nonnull %GS2, ptr noundef nonnull %GS2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp19) #4
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %GS3) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(24) %GS3, ptr addrspace(2) noundef align 8 dereferenceable(24) @__const.test_ndrange_2D3D.GS3, i64 24, i1 false)
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %LS3) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(24) %LS3, ptr addrspace(2) noundef align 8 dereferenceable(24) @__const.test_ndrange_2D3D.LS3, i64 24, i1 false)
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %WO3) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(24) %WO3, ptr addrspace(2) noundef align 8 dereferenceable(24) @__const.test_ndrange_2D3D.WO3, i64 24, i1 false)
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp21) #4
  call spir_func void @_Z10ndrange_3DPKm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp21, ptr noundef nonnull %GS3) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp21) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp24) #4
  call spir_func void @_Z10ndrange_2DPKmS0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp24, ptr noundef nonnull %GS3, ptr noundef nonnull %LS3) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp24) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp28) #4
  call spir_func void @_Z10ndrange_2DPKmS0_S0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp28, ptr noundef nonnull %WO3, ptr noundef nonnull %GS3, ptr noundef nonnull %LS3) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp28) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp31) #4
  call spir_func void @_Z10ndrange_2DPKmS0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp31, ptr noundef nonnull %GS3, ptr noundef nonnull %GS3) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp31) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp35) #4
  call spir_func void @_Z10ndrange_2DPKmS0_S0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp35, ptr noundef nonnull %GS3, ptr noundef nonnull %GS3, ptr noundef nonnull %GS3) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp35) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp36) #4
  call spir_func void @_Z10ndrange_1Dm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp36, i64 noundef 1) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp36) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp37) #4
  call spir_func void @_Z10ndrange_1Dmm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp37, i64 noundef 1, i64 noundef 2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp37) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp38) #4
  call spir_func void @_Z10ndrange_1Dmmm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp38, i64 noundef 3, i64 noundef 1, i64 noundef 2) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp38) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp39) #4
  call spir_func void @_Z10ndrange_1Dmm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp39, i64 noundef 1, i64 noundef 1) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp39) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp40) #4
  call spir_func void @_Z10ndrange_1Dmmm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp40, i64 noundef 1, i64 noundef 1, i64 noundef 1) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp40) #4
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %GS2c) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(16) %GS2c, ptr addrspace(2) noundef align 8 dereferenceable(16) @__const.test_ndrange_2D3D.GS2c, i64 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %LS2c) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(16) %LS2c, ptr addrspace(2) noundef align 8 dereferenceable(16) @__const.test_ndrange_2D3D.LS2c, i64 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %WO2c) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(16) %WO2c, ptr addrspace(2) noundef align 8 dereferenceable(16) @__const.test_ndrange_2D3D.WO2c, i64 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp42) #4
  call spir_func void @_Z10ndrange_2DPKm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp42, ptr noundef nonnull %GS2c) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp42) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp45) #4
  call spir_func void @_Z10ndrange_2DPKmS0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp45, ptr noundef nonnull %GS2c, ptr noundef nonnull %LS2c) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp45) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp49) #4
  call spir_func void @_Z10ndrange_2DPKmS0_S0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp49, ptr noundef nonnull %WO2c, ptr noundef nonnull %GS2c, ptr noundef nonnull %LS2c) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp49) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp52) #4
  call spir_func void @_Z10ndrange_2DPKmS0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp52, ptr noundef nonnull %GS2c, ptr noundef nonnull %GS2c) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp52) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp56) #4
  call spir_func void @_Z10ndrange_2DPKmS0_S0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp56, ptr noundef nonnull %GS2c, ptr noundef nonnull %GS2c, ptr noundef nonnull %GS2c) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp56) #4
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %GS3c) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(24) %GS3c, ptr addrspace(2) noundef align 8 dereferenceable(24) @__const.test_ndrange_2D3D.GS3c, i64 24, i1 false)
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %LS3c) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(24) %LS3c, ptr addrspace(2) noundef align 8 dereferenceable(24) @__const.test_ndrange_2D3D.LS3c, i64 24, i1 false)
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %WO3c) #4
  call void @llvm.memcpy.p0.p2.i64(ptr noundef nonnull align 8 dereferenceable(24) %WO3c, ptr addrspace(2) noundef align 8 dereferenceable(24) @__const.test_ndrange_2D3D.WO3c, i64 24, i1 false)
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp58) #4
  call spir_func void @_Z10ndrange_3DPKm(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp58, ptr noundef nonnull %GS3c) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp58) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp61) #4
  call spir_func void @_Z10ndrange_2DPKmS0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp61, ptr noundef nonnull %GS3c, ptr noundef nonnull %LS3c) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp61) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp65) #4
  call spir_func void @_Z10ndrange_2DPKmS0_S0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp65, ptr noundef nonnull %WO3c, ptr noundef nonnull %GS3c, ptr noundef nonnull %LS3c) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp65) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp68) #4
  call spir_func void @_Z10ndrange_2DPKmS0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp68, ptr noundef nonnull %GS3c, ptr noundef nonnull %GS3c) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp68) #4
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %tmp72) #4
  call spir_func void @_Z10ndrange_2DPKmS0_S0_(ptr dead_on_unwind nonnull writable sret(%struct.ndrange_t) align 8 %tmp72, ptr noundef nonnull %GS3c, ptr noundef nonnull %GS3c, ptr noundef nonnull %GS3c) #5
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %tmp72) #4
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %WO3c) #4
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %LS3c) #4
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %GS3c) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %WO2c) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %LS2c) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %GS2c) #4
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %WO3) #4
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %LS3) #4
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %GS3) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %WO2) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %LS2) #4
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %GS2) #4
  ret void
}

declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1
declare spir_func void @_Z10ndrange_1Dm(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, i64 noundef) local_unnamed_addr #2
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1
declare spir_func void @_Z10ndrange_1Dmm(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, i64 noundef, i64 noundef) local_unnamed_addr #2
declare spir_func void @_Z10ndrange_1Dmmm(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, i64 noundef, i64 noundef, i64 noundef) local_unnamed_addr #2
declare void @llvm.memcpy.p0.p2.i64(ptr noalias nocapture writeonly, ptr addrspace(2) noalias nocapture readonly, i64, i1 immarg) #3
declare spir_func void @_Z10ndrange_2DPKm(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, ptr noundef) local_unnamed_addr #2
declare spir_func void @_Z10ndrange_2DPKmS0_(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, ptr noundef, ptr noundef) local_unnamed_addr #2
declare spir_func void @_Z10ndrange_2DPKmS0_S0_(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #2
declare spir_func void @_Z10ndrange_3DPKm(ptr dead_on_unwind writable sret(%struct.ndrange_t) align 8, ptr noundef) local_unnamed_addr #2
