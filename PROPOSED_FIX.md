# hip_cooperative_groups under amdgcnspirv — root cause & fix (ROCm/llvm-project#3143)

## Summary

`HIP-Basic/cooperative_groups` (ctest `hip_cooperative_groups`) is excluded from
the SPIRV CI because it fails on **gfx942**
(`.github/workflows/spirv-ci-linux-amd-staging.yml`, HIP-Basic run step,
`-E '^hip_cooperative_groups$' # TODO: ISSUE #3143`). It **passes** on the local
gfx90a/MI210 test GPU, so the failure is architecture-specific and cannot be
reproduced locally.

Root cause is a **compiler bug in the amdgcnspirv (SPIR-V backend) lowering of
`__builtin_amdgcn_is_invocable`** for builtins that have *no* required target
features. It produces a degenerate, empty feature predicate that is resolved
per-processor by the SPIR-V consumer and is not guaranteed to be true — silently
dropping the guarded `__syncthreads()` block barrier and breaking the reduction.

## What the example uses (source citations)

The example is intra-block only; it does NOT use grid-wide sync.

- `HIP-Basic/cooperative_groups/main.hip:79` `this_thread_block()` (workgroup group).
- `main.hip:50` and `main.hip:59` `g.sync()` inside `reduce_sum()` — the group is
  passed as `thread_group` by value, so this dispatches through
  `thread_group::sync()`
  (`amd_hip_cooperative_groups.h:735`), whose `cg_workgroup` case calls
  `internal::workgroup::sync()` → `__syncthreads()`
  (`hip_cooperative_groups_helper.h:223`).
- `main.hip:99-107` `tiled_partition<16>` + reduction on the tile; the tile's
  `sync()` is a wavefront-scope fence (`hip_cooperative_groups_helper.h:250-253`).
- `main.hip:199` launches via `hipLaunchCooperativeKernel` with `num_blocks=1`
  (`main.hip:158`), `threads_per_block=64` (`main.hip:161`). Single block, wave64:
  the cooperative *launch* itself needs no grid-wide barrier support, so this is
  NOT a grid-sync problem.

`__syncthreads()` expands (clr `amd_device_functions.h:718-722`) to
`__work_group_barrier()` (`amd_device_functions.h:697-716`), which guards the
`s_barrier`+fence behind:

```
if (__builtin_amdgcn_is_invocable(__builtin_amdgcn_fence) &&
    __builtin_amdgcn_is_invocable(__builtin_amdgcn_s_barrier)) { ... }
```

## The bug (concrete IR evidence)

Compiling the example to amdgcnspirv (device-only, both `-O0` and `-O3`) with the
staging toolchain:

```
clang++ -x hip --offload-arch=amdgcnspirv ... -O3 -emit-llvm -S \
  main.hip -o coop_o3.ll
```

shows the block barrier fully gated by an **empty** feature predicate:

```
!44 = !{!"has."}                       ; empty feature name

_ZL20__work_group_barrierj:
  %0 = call i1 @llvm.spv.named.boolean.spec.constant(i32 -1, i1 false, metadata !44)
  br i1 %0, label %land.lhs.true, label %if.end10   ; if false -> skip everything
land.lhs.true:
  %1 = call i1 @llvm.spv.named.boolean.spec.constant(i32 -1, i1 false, metadata !44)
  br i1 %1, label %if.then, label %if.end10
if.then1:
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()               ; the actual __syncthreads()
  fence syncscope("workgroup") acquire
```

Origin of the empty predicate — `clang/lib/CodeGen/TargetBuiltins/AMDGPU.cpp`
(pre-fix):

```cpp
case AMDGPU::BI__builtin_amdgcn_is_invocable: {
  ...
  StringRef RF = getContext().BuiltinInfo.getRequiredFeatures(FD->getBuiltinID());
  return GetAMDGPUPredicate(*this, "has." + RF);   // RF == "" here
}
```

`__builtin_amdgcn_fence` (`BuiltinsAMDGPU.td:160`) and `__builtin_amdgcn_s_barrier`
(`BuiltinsAMDGPU.td:152`) have **no** required-features string, so `RF` is empty and
the predicate name is just `"has."`.

`GetAMDGPUPredicate` (AMDGPU.cpp:476) lowers this to
`Intrinsic::spv_named_boolean_spec_constant`, which the SPIR-V ISel emits as
`OpSpecConstantFalse` with a `SpecId`
(`llvm/lib/Target/SPIRV/SPIRVInstructionSelector.cpp:5068-5081`). The predicate
name → SpecId map is exported as `llvm.amdgcn.feature.predicate.ids`
(`llvm/lib/Target/SPIRV/SPIRVPrepareGlobals.cpp:82-125`) for the consumer to
override at SPIR-V-consumption / JIT time for the concrete GPU.

For a **real** feature (e.g. `has.gfx1250-insts`, metadata !33) this is correct:
the consumer knows the target's features and sets the spec constant accordingly
(false on gfx942 for gfx1250 insts — correct). But for the **empty** `"has."`
predicate the intended meaning is "always invocable" (the builtin has no feature
requirement). The concrete-target code path confirms this: for an empty required-
features string, `Builtin::evaluateRequiredTargetFeatures()` returns **true**
(`clang/lib/Basic/Builtins.cpp:468-478`). On the SPIR-V path, however, the value is
left to the consumer to resolve from a degenerate empty feature name; it defaults
to `OpSpecConstantFalse` and is not reliably overridden, so on gfx942 the guarded
barrier is dropped.

## Why gfx942 fails but gfx90a passes

The value of a spec constant with an empty/degenerate predicate name is resolved
by the per-GPU SPIR-V consumer (comgr/translator, not in this repo). The resolution
differs by processor; on gfx90a the guarded block is (by chance / consumer detail)
kept, on gfx942 it is dropped. When `__syncthreads()` is elided, the shared-memory
reduction in `reduce_sum()` (`main.hip:44-60`) races and yields wrong sums →
`Validation failed` (`main.hip:242`). This is a **genuine miscompile**, not a
flaky/timing issue: the barrier is statically removed, so it fails deterministically
on the affected arch.

## Fix (applied in this branch)

`clang/lib/CodeGen/TargetBuiltins/AMDGPU.cpp`, in the
`BI__builtin_amdgcn_is_invocable` case: when the builtin has no required features,
fold the predicate to a compile-time `true` instead of emitting a degenerate
`"has."` specialization constant:

```cpp
if (RF.empty())
  return Builder.getTrue();
return GetAMDGPUPredicate(*this, "has." + RF);
```

This matches the concrete-target semantics
(`Builtin::evaluateRequiredTargetFeatures("") == true`) and removes the empty
predicate from the emitted SPIR-V, so the `__syncthreads()` block barrier is always
present on every AMDGCN target, including gfx942. Feature-gated builtins (non-empty
RF) are unchanged and still lower to a proper per-arch spec constant.

Verified: the edited translation unit compiles cleanly against the prebuilt
staging build tree (single-TU rebuild of `AMDGPU.cpp.o`). A full LLVM rebuild +
gfx942 run was not feasible in-session, so end-to-end validation on gfx942 is
pending; the local gfx90a run still PASSES (bug never reproduced there).

## Once the compiler fix lands

Remove the exclusion in `.github/workflows/spirv-ci-linux-amd-staging.yml`:

```
-          ctest --test-dir examples-build-hip-basic --output-on-failure -j $(nproc) \
-            -E '^hip_cooperative_groups$' # TODO: ISSUE #3143
+          ctest --test-dir examples-build-hip-basic --output-on-failure -j $(nproc)
```

(Left in place in this branch until the compiler fix is validated on gfx942, to
avoid re-breaking CI.)

## Confidence

- Empty `"has."` predicate statically gating the block barrier at `-O0` and `-O3`:
  **high** (direct IR evidence).
- Concrete-target semantics of empty required-features == true: **high**
  (`Builtins.cpp`).
- That this specific empty-predicate resolution is THE gfx942 runtime failure:
  **moderate-to-high**. The SPIR-V consumer that assigns the spec-constant value
  is not in this repo, so the "defaults to false on gfx942" step is inferred from
  the emission side (`OpSpecConstantFalse` default) rather than observed. The fix
  is nonetheless correct regardless: an empty required-features predicate must be
  unconditionally true, and eliminating it removes an arch-dependent degree of
  freedom from a correctness-critical barrier.
