<!-- SPDX-License-Identifier: MPL-2.0 -->

# CoreShift-GKI

CoreShift-GKI is a GitHub Actions-based Android GKI LTS kernel builder.

It helps you build flashable custom GKI kernels without setting up a full Android kernel build environment locally. You choose a kernel family, root manager, and optional features in GitHub Actions, then download the generated output.

> Custom kernels can bootloop your device. Use this only if you know how to recover with recovery or fastboot.

## What CoreShift-GKI Builds

CoreShift-GKI can build Android GKI LTS kernels for supported Android kernel families and package them into flashable AnyKernel zip files.

It is designed for:

- Android power users
- Root users
- Custom ROM users
- Kernel testers
- Users who can recover from a bad kernel flash

It is not a universal compatibility layer. A build that boots on one device, ROM, or Android version may not boot on another.

## Supported Kernel Families

| Android GKI family | Kernel version |
| --- | --- |
| Android 12 GKI | `5.10` |
| Android 14 GKI | `6.1` |
| Android 15 GKI | `6.6` |

Your selected GKI version must match your device and ROM.

## Supported Root Manager Choices

| Choice | Meaning |
| --- | --- |
| `Vanilla` | No root manager |
| `KernelSU` | KernelSU support |
| `KernelSU-Next` | KernelSU-Next support |
| `KowSU` | KowSU support |
| `ResukiSU` | ResukiSU support |
| `Rissu` | Rissu support |
| `Wild_KSU` | Wild_KSU support |

For your first root build, choose one manager and keep advanced features off. Confirm the kernel boots before enabling SUSFS or other extra features.

## Build Workflows

| Workflow | Purpose | Notes |
| --- | --- | --- |
| **Build Kernel** | Build one simpler manual kernel with stable defaults. | Good first choice. Fewer advanced config toggles than Custom. |
| **Custom Kernel Build** | Build one kernel with advanced manual options for source, Clang, and feature testing. | Best for custom `kernel/common`, curated Clang testing, and advanced config tuning. |
| **Build Kernel Release Matrix** | Build the curated stable release set. | Recommended release path. No experimental Clang selector. |
| **Build Experimental Kernel Release Matrix** | Build the curated release matrix with selectable curated Clang versions and maintained experimental `kernel/common` sources. | Experimental path. Includes experimental-only `6.12` support and may break boot, Wi-Fi, modules, root, or KMI compatibility. |

Most users should start with **Build Kernel**. Use **Custom Kernel Build** only when you need extra control. Use the experimental release matrix only for Clang testing.

## Quick Start

1. Fork this repository.
2. Open the **Actions** tab in your fork.
3. Choose a workflow.
4. Select your kernel version, manager, and options.
5. Run the workflow.
6. Download the generated AnyKernel zip or artifact.
7. Flash only after confirming you selected the correct GKI version for your device.

## Recommended Starting Points

| Goal | Recommended settings |
| --- | --- |
| First test build | `Vanilla`, thin LTO, advanced options off |
| First root build | One root manager, SUSFS off, BBG off |
| SUSFS build | Confirm the same manager boots first, then enable SUSFS |
| BBG build | Confirm the non-BBG build boots first, then enable BBG |
| Debug build | Enable debug features only when troubleshooting |

Start small. Boot a basic build first, then add one advanced feature at a time.

## Option Guide

| Option | Meaning |
| --- | --- |
| `kernel_version` | Target Android GKI family: `5.10`, `6.1`, or `6.6`. |
| `manager` | Root manager integration. Use `Vanilla` for no root manager. |
| `manager_ref` | Optional manager git ref, commit, or tag for advanced testing. |
| `source_repo` | Optional replacement Git repository for `kernel/common`. Stable workflows keep the default Google GKI sync path. Experimental release uses maintained source repos by default unless you override this manually. |
| `source_ref` | Optional branch, tag, or commit from `source_repo`. Not guaranteed stable. |
| `clang_version` | Clang selector. `default` uses the synced/build-tree toolchain, `clang-r584948` uses the current curated Clang, and `clang-r547379` uses the Android 16 release Clang. |
| `lto` | Link-time optimization. `thin` is the safest default. |
| `susfs` | SUSFS4KSU support. Advanced root-hiding/spoofing feature. |
| `baseband_guard` | Baseband Guard support. Advanced protection feature. |
| `container_features` | Enables container-related kernel options in custom builds. |
| `performance_features` | Enables performance-oriented options. Use only when needed. |
| `debug_features` | Enables debugging/tracing options. Not needed for normal use. |
| `strict_config` | Fails the build if required config options are missing. |
| `legacy_kmi_check` | Controls the legacy 5.10 KMI check behavior. |
| `publish_mode` | Chooses release output, artifact output, or both. |

Some workflows intentionally hide low-level fragment toggles to keep normal builds simpler and safer. Stable release matrix builds stay fixed and curated. Experimental release matrix builds add curated Clang selection, maintained default source repos, optional source override, and experimental `6.12` support.

### Experimental Source Defaults

The experimental release workflow uses these `kernel/common` repos by default unless you set `source_repo` yourself:

- `5.10`: `https://github.com/ramabondanp/android_kernel_common-5.10`
- `6.1`: `https://github.com/ramabondanp/android_kernel_common-6.1`
- `6.6`: `https://github.com/ramabondanp/android_kernel_common-6.6`
- `6.12`: `https://github.com/ramabondanp/android_kernel_common-6.12`

These are experimental defaults, not stable release defaults.

## Safety Checklist

Before flashing any build:

- Back up your current `boot`, `init_boot`, and `vendor_boot` images if your device uses them.
- Keep a known-good kernel, boot image, or ROM package ready.
- Know how to use recovery or fastboot.
- Confirm your device uses the selected GKI kernel family.
- Test a basic build before enabling SUSFS, BBG, container, performance, or debug features.
- Do not flash builds meant for a different Android/GKI family.

Flash at your own risk.

## Compatibility Notes

CoreShift-GKI builds Android GKI kernels, but compatibility still depends on your device, ROM, vendor modules, boot image layout, and Android version.

A kernel may fail to boot if:

- The selected GKI version does not match your ROM.
- Vendor modules are incompatible.
- The boot image layout differs from what the package expects.
- A root manager or advanced patch is incompatible with your kernel family.
- SUSFS or BBG changes conflict with your device or ROM.

When testing, change one thing at a time.

## Outputs

Custom builds can publish outputs in three modes:

| Mode | Output |
| --- | --- |
| `artifact` | Uploads build artifacts through GitHub Actions. |
| `release` | Creates a GitHub release. |
| `both` | Uploads artifacts and creates a release. |

Typical outputs include:

- Flashable AnyKernel zip
- Raw kernel `Image`
- Exported kernel config
- `compiler-version.txt`

Most users should flash the **AnyKernel zip**, not the raw `Image`.

### Compiler Metadata

Each workflow that publishes artifacts can include `compiler-version.txt`. It records the selected Clang path and compiler/linker version data from CI.

After boot, compare it with:

- `uname -a`
- `cat /proc/version`

### Artifact Note

GitHub downloads artifacts as zip files. To avoid a zip-inside-zip problem, artifact mode may upload a staged AnyKernel tree instead of uploading an already zipped package.

## Troubleshooting

| Problem | What to try |
| --- | --- |
| Build failed | Re-run with fewer options. Start from `Vanilla` and thin LTO. |
| Device bootloops | Restore your boot images or flash a known-good kernel. |
| Full LTO build was killed | Use thin LTO. Full LTO needs more memory. |
| Experimental Clang build breaks boot or modules | Go back to `clang_version=default` or the stable release matrix workflow. |
| Root manager is not detected | Build the manager without SUSFS first, then test SUSFS separately. |
| SUSFS does not work | Confirm the same manager boots without SUSFS first. |
| BBG causes issues | Test the same build with BBG off, then compare logs. |
| Feature does not work | Rebuild with only that feature enabled. |
| Wrong kernel version | Rebuild with the GKI version used by your ROM/device. |

## Recovery Reminder

A successful build does not guarantee a successful boot. Keep recovery access ready before flashing.

## License

This project is licensed under the Mozilla Public License 2.0. See [LICENSE](LICENSE).
