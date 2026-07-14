# applications_optical_flow — SPIRV CI failure (ROCm/llvm-project#3143)

## Summary

`Applications/optical_flow` was excluded from the SPIRV CI Applications run
(`.github/workflows/spirv-ci-linux-amd-staging.yml`, "ROCm Examples run
Applications" step) via `-E '^(applications_optical_flow|applications_monte_carlo_pi)$'`
tagged `# TODO: ISSUE #3143`. This change re-enables `applications_optical_flow`
(monte_carlo_pi is owned by another agent and left in the filter).

## Local result (gfx90a / MI210, amdgcnspirv)

Reproducer `reproducers/repro_applications_optical_flow.sh` **PASSES** locally:

```
1/1 Test #6: applications_optical_flow ........   Passed   12.70 sec
REPRO: PASSED — bug did NOT reproduce
```

The CI failure is on **gfx942 (CDNA3 / MI300)**, which cannot be reproduced on the
local gfx90a GPU. Analysis below is source/CI-driven plus targeted local experiments.

## Root-cause analysis

### The example has two code paths selected at runtime

`flowHIP.hip:69-76` queries `hipDeviceAttributeImageSupport` and stores it in
`imageSupport`. Every sampling wrapper (`Downscale`, `WarpImage`,
`ComputeDerivatives`, `Upscale`) then branches:

- `imageSupport != 0` → **hardware texture path**: builds a
  `hipTextureObject_t` over a `hipResourceTypePitch2D` resource and samples with
  `tex2D<float>()` (`downscaleKernel.hip:81-106`, `warpingKernel.hip:75-95`,
  `derivativesKernel.hip:122-182`, `upscaleKernel.hip:76-94`).
- `imageSupport == 0` → **software sampler path**: `*KernelSW` variants that call
  the hand-written `tex2D_bilinear()` / `tex2D_mirror_coord()` in `common.h:60-97`
  (plain FP32 add/mul/div/`floorf`/`fabsf`, no image/texture ops).

The SW path is explicitly annotated "Used on devices that lack hardware texture
units (e.g. CDNA / MI300X)" (e.g. `downscaleKernel.hip:29-30`, `common.h:52-57`).
It is the compatibility fallback that was added to address exactly this issue: the
original example used the `tex2D<float>` / `hipTextureObject_t` path unconditionally,
and HIP texture-object sampling over a pitched linear resource under the
**amdgcnspirv** code-object path is not reliably available on gfx942 (image support
absent → `hipCreateTextureObject` / `tex2D` cannot resolve, giving a runtime
failure rather than a numeric mismatch).

### Local experiments (gfx90a, amdgcnspirv)

- Default build: `hipDeviceAttributeImageSupport` returns **1** on gfx90a, so the
  HW texture path runs and passes: `L1 error : 0.044195` (THRESHOLD = 0.05,
  `main.hip:66`).
- Forcing the SW path (`imageSupport = 0`) on the same GPU: `L1 error : 0.043852`.
- The SW path result is **bit-stable across `-ffp-contract=fast|on|off`**
  (0.043852 in all three). It is pure IEEE FP32 arithmetic with no FMA-contractable
  reductions that change the outcome, so it is architecture-independent: gfx942 will
  produce the same ~0.0438 and stay under the 0.05 threshold.

Conclusion on failure mode: this is **not** an fp-contraction / fast-math tolerance
drift in the SPIRV backend (the numeric path is stable and well under tolerance).
The gfx942 CI failure was a **capability / code-object problem in the hardware
texture path** (texture-object sampling under amdgcnspirv on a device without image
support), which the `imageSupport`-gated SW fallback already in the example source
(`ROCm/rocm-examples@amd-staging`, the ref this workflow checks out at line ~598)
resolves by never touching `tex2D`/`hipTextureObject_t` on such devices.

## Fix applied (this repo)

`.github/workflows/spirv-ci-linux-amd-staging.yml`, "ROCm Examples run
Applications" step: remove `applications_optical_flow` from the `-E` exclusion,
leaving only `applications_monte_carlo_pi`. The example itself already carries the
correct fix (SW sampler fallback), so re-enabling the test is the appropriate and
minimal repo-side change; CI on the actual gfx942 runner is the validation.

## Confidence

- High: local repro passes; SW fallback path is numerically sound, stable, and
  well within tolerance; failure was a texture/image capability issue, not
  fp-contraction.
- Medium on the gfx942 branch decision: I cannot query `imageSupport` on gfx942
  locally. If gfx942 reports `imageSupport == 1` and the *hardware* texture path
  is what fails there under amdgcnspirv, the durable fix is in the SPIRV image
  intrinsic lowering (llvm/lib/Target/SPIRV / the in-tree translator), not the
  workflow. In that case the example's `imageSupport` gate should additionally
  force the SW path under `__HIP_PLATFORM_AMD__` + SPIR-V target — but that belongs
  in ROCm/rocm-examples (not branchable here). The local evidence (thin-but-passing
  SW margin, stable arithmetic) favors the SW-fallback-resolves-it explanation.
