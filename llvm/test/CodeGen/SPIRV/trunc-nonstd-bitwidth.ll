; RUN: llc -O0 -verify-machineinstrs -mtriple=spirv64-unknown-unknown %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-NOEXT
; RUN: %if spirv-tools %{ llc -O0 -verify-machineinstrs -mtriple=spirv64-unknown-unknown %s -o - -filetype=obj | spirv-val %}

; RUN: llc -O0 -verify-machineinstrs -mtriple=spirv64-unknown-unknown %s --spirv-ext=+SPV_ALTERA_arbitrary_precision_integers -o - | FileCheck %s --check-prefixes=CHECK,CHECK-EXT
; RUN: %if spirv-tools %{ llc -verify-machineinstrs -O0 -mtriple=spirv64-unknown-unknown %s --spirv-ext=+SPV_ALTERA_arbitrary_precision_integers -o - -filetype=obj | spirv-val %}

; RUN: llc -O0 -verify-machineinstrs -mtriple=spirv32-unknown-unknown %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-NOEXT
; RUN: %if spirv-tools %{ llc -O0 -verify-machineinstrs -mtriple=spirv32-unknown-unknown %s -o - -filetype=obj | spirv-val %}

; RUN: llc -O0 -verify-machineinstrs -mtriple=spirv32-unknown-unknown %s --spirv-ext=+SPV_ALTERA_arbitrary_precision_integers -o - | FileCheck %s --check-prefixes=CHECK,CHECK-EXT
; RUN: %if spirv-tools %{ llc -verify-machineinstrs -O0 -mtriple=spirv32-unknown-unknown %s --spirv-ext=+SPV_ALTERA_arbitrary_precision_integers -o - -filetype=obj | spirv-val %}

; CHECK-EXT-DAG: %[[#Int40:]] = OpTypeInt 40 0
; CHECK-EXT-DAG: %[[#Int50:]] = OpTypeInt 50 0
; CHECK-EXT-DAG: %[[#Int24:]] = OpTypeInt 24 0
; CHECK-EXT-DAG: %[[#Int5:]] = OpTypeInt 5 0
; CHECK-NOEXT-DAG: %[[#Int64:]] = OpTypeInt 64 0
; CHECK-NOEXT-DAG: %[[#Int32:]] = OpTypeInt 32 0
; CHECK-NOEXT-DAG: %[[#Int16:]] = OpTypeInt 16 0
; CHECK-NOEXT-DAG: %[[#Int8:]] = OpTypeInt 8 0

; Test i64 -> i40: both widen to i64, G_TRUNC replaced with G_AND
; CHECK: OpFunction
; CHECK: %[[#T1Arg:]] = OpFunctionParameter
; CHECK: %[[#T1Val:]] = OpFunctionParameter
; CHECK-EXT: %[[#T1Tr:]] = OpUConvert %[[#Int40]] %[[#T1Val]]
; CHECK-EXT: OpStore %[[#T1Arg]] %[[#T1Tr]]
; CHECK-NOEXT: %[[#T1And:]] = OpBitwiseAnd %[[#Int64]] %[[#T1Val]] %[[#]]
; CHECK-NOEXT: OpStore %[[#T1Arg]] %[[#T1And]]
define spir_kernel void @trunc_i64_to_i40(ptr addrspace(1) %arg, i64 %val) {
  %tr = trunc i64 %val to i40
  store i40 %tr, ptr addrspace(1) %arg
  ret void
}

; Test i50 -> i24: src widens to i64, dst widens to i32, need OpUConvert after OpBitwiseAnd
; CHECK: OpFunction
; CHECK: %[[#T2Arg:]] = OpFunctionParameter
; CHECK: %[[#T2Val:]] = OpFunctionParameter
; CHECK-EXT: %[[#T2Tr:]] = OpUConvert %[[#Int24]] %[[#T2Val]]
; CHECK-EXT: OpStore %[[#T2Arg]] %[[#T2Tr]]
; CHECK-NOEXT: %[[#T2And:]] = OpBitwiseAnd %[[#Int64]] %[[#T2Val]] %[[#]]
; CHECK-NOEXT: %[[#T2Conv:]] = OpUConvert %[[#Int32]] %[[#T2And]]
; CHECK-NOEXT: OpStore %[[#T2Arg]] %[[#T2Conv]]
define spir_kernel void @trunc_i50_to_i24(ptr addrspace(1) %arg, i50 %val) {
  %tr = trunc i50 %val to i24
  store i24 %tr, ptr addrspace(1) %arg
  ret void
}


; Test i64 -> i24: src stays i64, dst widens to i32, need OpUConvert after OpBitwiseAnd
; CHECK: OpFunction
; CHECK: %[[#T3Arg:]] = OpFunctionParameter
; CHECK: %[[#T3Val:]] = OpFunctionParameter
; CHECK-EXT: %[[#T3Tr:]] = OpUConvert %[[#Int24]] %[[#T3Val]]
; CHECK-EXT: OpStore %[[#T3Arg]] %[[#T3Tr]]
; CHECK-NOEXT: %[[#T3And:]] = OpBitwiseAnd %[[#Int64]] %[[#T3Val]] %[[#]]
; CHECK-NOEXT: %[[#T3Conv:]] = OpUConvert %[[#Int32]] %[[#T3And]]
; CHECK-NOEXT: OpStore %[[#T3Arg]] %[[#T3Conv]]
define spir_kernel void @trunc_i64_to_i24(ptr addrspace(1) %arg, i64 %val) {
  %tr = trunc i64 %val to i24
  store i24 %tr, ptr addrspace(1) %arg
  ret void
}

; Test i16 -> i5: src stays i16, dst widens to i8, need OpUConvert after OpBitwiseAnd
; CHECK: OpFunction
; CHECK: %[[#T4Arg:]] = OpFunctionParameter
; CHECK: %[[#T4Val:]] = OpFunctionParameter
; CHECK-EXT: %[[#T4Tr:]] = OpUConvert %[[#Int5]] %[[#T4Val]]
; CHECK-EXT: OpStore %[[#T4Arg]] %[[#T4Tr]]
; CHECK-NOEXT: %[[#T4And:]] = OpBitwiseAnd %[[#Int16]] %[[#T4Val]] %[[#]]
; CHECK-NOEXT: %[[#T4Conv:]] = OpUConvert %[[#Int8]] %[[#T4And]]
; CHECK-NOEXT: OpStore %[[#T4Arg]] %[[#T4Conv]]
define spir_kernel void @trunc_i16_to_i5(ptr addrspace(1) %arg, i16 %val) {
  %tr = trunc i16 %val to i5
  store i5 %tr, ptr addrspace(1) %arg
  ret void
}
