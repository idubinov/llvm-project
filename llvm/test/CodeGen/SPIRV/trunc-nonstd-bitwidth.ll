; RUN: llc -O0 -mtriple=spirv64-unknown-unknown %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-NOEXT
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-unknown-unknown %s -o - -filetype=obj | spirv-val %}

; RUN: llc -O0 -mtriple=spirv64-unknown-unknown %s --spirv-ext=+SPV_ALTERA_arbitrary_precision_integers -o - | FileCheck %s --check-prefixes=CHECK,CHECK-EXT

; RUN: llc -O0 -mtriple=spirv32-unknown-unknown %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-NOEXT
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv32-unknown-unknown %s -o - -filetype=obj | spirv-val %}

; RUN: llc -O0 -mtriple=spirv32-unknown-unknown %s --spirv-ext=+SPV_ALTERA_arbitrary_precision_integers -o - | FileCheck %s --check-prefixes=CHECK,CHECK-EXT
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv32-unknown-unknown %s --spirv-ext=+SPV_ALTERA_arbitrary_precision_integers -o - -filetype=obj | spirv-val %}

; TODO: This test currently fails with LLVM_ENABLE_EXPENSIVE_CHECKS enabled
; XFAIL: expensive_checks

; CHECK-DAG: OpName %[[#Struct:]] "struct"
; CHECK-DAG: %[[#Struct]] = OpTypeStruct %[[#]] %[[#]] %[[#]]
; CHECK-DAG: %[[#PtrStruct:]] = OpTypePointer CrossWorkgroup %[[#Struct]]
; CHECK-EXT-DAG: %[[#Int40:]] = OpTypeInt 40 0
; CHECK-EXT-DAG: %[[#Int50:]] = OpTypeInt 50 0
; CHECK-EXT-DAG: %[[#Int24:]] = OpTypeInt 24 0
; CHECK-EXT-DAG: %[[#Int5:]] = OpTypeInt 5 0
; CHECK-NOEXT-DAG: %[[#Int40:]] = OpTypeInt 64 0
; CHECK-DAG: %[[#PtrInt40:]] = OpTypePointer CrossWorkgroup %[[#Int40]]

; CHECK: OpFunction
; CHECK: %[[#Arg:]] = OpFunctionParameter
; CHECK-EXT: %[[#Tr:]] = OpUConvert %[[#Int40]] %[[#R:]]
; CHECK-EXT: %[[#Store:]] = OpInBoundsPtrAccessChain %[[#PtrStruct]] %[[#Arg]] %[[#]]
; CHECK-EXT: %[[#StoreAsInt40:]] = OpBitcast %[[#PtrInt40]] %[[#Store]]
; CHECK-EXT: OpStore %[[#StoreAsInt40]] %[[#Tr]]

; CHECK-NOEXT: %[[#Store:]] = OpInBoundsPtrAccessChain %[[#PtrStruct]] %[[#Arg]] %[[#]]
; CHECK-NOEXT: %[[#StoreAsInt40:]] = OpBitcast %[[#PtrInt40]] %[[#Store]]
; CHECK-NOEXT: OpStore %[[#StoreAsInt40]] %[[#R:]]

; CHECK: OpFunction

; CHECK: %[[#QArg:]] = OpFunctionParameter
; CHECK: %[[#Q:]] = OpFunctionParameter
; CHECK-EXT: %[[#Tq:]] = OpUConvert %[[#Int40]] %[[#Q]]
; CHECK-EXT: OpStore %[[#QArg]] %[[#Tq]]

; CHECK-NOEXT: %[[#TqNoext:]] = OpBitwiseAnd %[[#]] %[[#Q]] %[[#]]
; CHECK-NOEXT: OpStore %[[#QArg]] %[[#TqNoext]]

; Test 3: trunc to small non-standard width (i64 -> i24).
; CHECK: OpFunction
; CHECK: %[[#T3Arg:]] = OpFunctionParameter
; CHECK: %[[#T3Val:]] = OpFunctionParameter
; CHECK-EXT: %[[#T3Tr:]] = OpUConvert %[[#Int24]] %[[#T3Val]]
; CHECK-EXT: OpStore %[[#T3Arg]] %[[#T3Tr]]
; CHECK-NOEXT: %[[#T3Noext:]] = OpBitwiseAnd %[[#]] %[[#T3Val]] %[[#]]
; CHECK-NOEXT: OpStore %[[#T3Arg]] %[[#T3Noext]]

; Test 4: trunc to i5 (non-power-of-2, < 8 bits).
; In NOEXT mode, i5 widens to i8, so mask with 0x1F.
; CHECK: OpFunction
; CHECK: %[[#T4Arg:]] = OpFunctionParameter
; CHECK: %[[#T4Val:]] = OpFunctionParameter
; CHECK-EXT: %[[#T4Tr:]] = OpUConvert %[[#Int5]] %[[#T4Val]]
; CHECK-EXT: OpStore %[[#T4Arg]] %[[#T4Tr]]
; CHECK-NOEXT: %[[#T4Noext:]] = OpBitwiseAnd %[[#]] %[[#T4Val]] %[[#]]
; CHECK-NOEXT: OpStore %[[#T4Arg]] %[[#T4Noext]]

%struct = type <{ i32, i8, [3 x i8] }>

define spir_kernel void @foo(ptr addrspace(1) %arg, i64 %r) {
  %tr = trunc i64 %r to i40
  %addr = getelementptr inbounds %struct, ptr addrspace(1) %arg, i64 0
  store i40 %tr, ptr addrspace(1) %addr
  ret void
}

define spir_kernel void @bar(ptr addrspace(1) %qarg, i50 %q) {
  %tq = trunc i50 %q to i40
  store i40 %tq, ptr addrspace(1) %qarg
  ret void
}

; Trunc to small non-standard width (i64 -> i24).
define spir_kernel void @trunc_to_i24(ptr addrspace(1) %arg, i64 %val) {
  %tr = trunc i64 %val to i24
  store i24 %tr, ptr addrspace(1) %arg
  ret void
}

; Trunc to i5 (non-power-of-2, < 8 bits).
define spir_kernel void @trunc_to_i5(ptr addrspace(1) %arg, i16 %val) {
  %tr = trunc i16 %val to i5
  store i5 %tr, ptr addrspace(1) %arg
  ret void
}
