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

Android 16 `6.12` support is temporarily disabled while Android 16/Kleaf module and KMI issues are being cleaned up.

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
| **Build Kernel** | Build one manual kernel with stable defaults. | Single-build flow. Choose Google LTS, maintained, Pixel, or custom source with `source_mode`. Good first choice. |
| **Custom Kernel Build** | Build one kernel with advanced manual feature options. | Single-build flow. Choose Google LTS, maintained, Pixel, or custom source with `source_mode`. |
| **Build Kernel Release Matrix** | Build the curated stable release set. | Recommended release path. Uses Google/AOSP LTS sources. |
| **Build Experimental Kernel Release Matrix** | Build curated maintained-source or Pixel experimental release sets. | Experimental path. Uses maintained GitHub `kernel/common` defaults or official Pixel manifests and may break build, Wi-Fi, modules, root, KMI/KCFI, or boot. |

Most users should start with **Build Kernel**. Use **Custom Kernel Build** only when you need extra control. Use the experimental release matrix only for maintained-source or Pixel release testing.

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
| `source_mode` | Manual Build/Custom source choice. `google-lts` keeps the synced Google/AOSP LTS source; `maintained` uses the same maintained source mapping as the experimental release workflow; `pixel` uses an official Google Pixel kernel manifest branch; `custom` uses `source_repo`. |
| `pixel_branch` | Official Pixel kernel manifest branch used only when `source_mode=pixel`. Pixel mode is experimental and Pixel 6+ specific. |
| `source_repo` | Custom replacement Git repository for `kernel/common`, used only when `source_mode=custom`. |
| `source_ref` | Optional branch, tag, or commit for maintained/custom source replacement. Not guaranteed stable. |
| `kmi_bypass` | Experimental maintained/custom source workaround. Defaults to `off`; when set to `on`, bypasses strict Kleaf KMI symbol-list checks for incompatible replacement sources only. |
| `lto` | Link-time optimization. `thin` is the safest default. |
| `susfs` | SUSFS4KSU support. Advanced root-hiding/spoofing feature. Compatibility depends on the selected manager and the exact `kernel/common` source tree. |
| `baseband_guard` | Baseband Guard support. Advanced protection feature. |
| `container_features` | Enables container-related kernel options in custom builds. |
| `performance_features` | Enables performance-oriented options. Use only when needed. |
| `debug_features` | Enables debugging/tracing options. Not needed for normal use. |
| `strict_config` | Fails the build if required config options are missing. |
| `legacy_kmi_check` | Controls the legacy 5.10 KMI check behavior. |
| `publish_mode` | Chooses release output, artifact output, or both. |

Some workflows intentionally hide low-level fragment toggles to keep normal builds simpler and safer. Stable release matrix builds stay fixed and curated on Google/AOSP LTS sources. Experimental release matrix builds use maintained default source repos and optional source override.

### Release Matrix Files

- Stable release matrix workflow reads `.github/matrix/release.json`.
- Experimental release matrix workflow reads `.github/matrix/release_exp.json` for maintained/custom profiles and `.github/matrix/release_pixel.json` for Pixel profiles.
- `.github/matrix/release.json` contains only curated Google/AOSP-supported stable release variants.
- `.github/matrix/release_exp.json` contains curated maintained-source experimental variants.
- `.github/matrix/release_pixel.json` contains curated official Pixel-manifest experimental variants.

### Source Modes

Manual **Build Kernel** and **Custom Kernel Build** are single-build flows, not matrices. They support these source modes:

- `google-lts`: keep the Google/AOSP LTS source synced by the Android kernel manifest. No `kernel/common` replacement is performed, and expected-Clang materialization is skipped.
- `maintained`: replace `kernel/common` with the maintained source repo for the selected kernel family, using the same mapping as the experimental release workflow. Expected-Clang materialization runs after replacement.
- `pixel`: sync an official Google Pixel kernel manifest branch selected by `pixel_branch`. No maintained GitHub source replacement is performed. This mode is experimental, Pixel 6+ only, and not generic GKI LTS.
- `custom`: replace `kernel/common` with `source_repo` and optional `source_ref`. `source_repo` is required. Expected-Clang materialization runs after replacement.

Maintained, Pixel, and custom source modes are experimental. They can fail build, KMI, KCFI, module loading, Wi-Fi, root manager integration, or boot even when the Google LTS source path works. Pixel source builds may require Pixel-specific modules, images, and targets, and are not guaranteed to work on non-Pixel devices.

Google LTS, maintained, custom, stable release, and experimental release builds keep strict KMI symbol-list checking enabled by default. The `kmi_bypass` input is an explicit experimental workaround for testing incompatible maintained/custom replacement sources; it is off by default and is ignored for Google LTS. Enabling it can break vendor modules, Wi-Fi, modem, display, touch, audio, or boot, so use it only while testing source trees that cannot currently satisfy Google's symbol list.

### Maintained Source Defaults

The manual `source_mode=maintained` flow and the experimental release workflow use these maintained `kernel/common` repos by default:

- `5.10`: `https://github.com/ramabondanp/android_kernel_common-5.10`
- `6.1`: `https://github.com/ramabondanp/android_kernel_common-6.1`
- `6.6`: `https://github.com/ramabondanp/android_kernel_common-6.6`

These are experimental defaults, not stable release defaults.

### Pixel Source Defaults

The manual `source_mode=pixel` flow and the experimental `source_profile=pixel` matrix use official Google Pixel kernel manifest branches:

- `android14-gs-pixel-6.1`
- `android-gs-raviole-6.1-android16`
- `android-gs-bluejay-6.1-android16`
- `android-gs-akita-6.1-android16`

Pixel source mode is experimental, Pixel 6+ specific, and not generic GKI LTS. It may need Pixel-specific modules or images and can fail on non-Pixel devices. If a Pixel branch does not expose `//common:kernel_aarch64_dist`, the build reports that target mismatch instead of pretending the generic GKI target is valid.

Pixel validation status:

- `android14-gs-pixel-6.1`: release matrix includes validated Vanilla,
  `KernelSU`, `KowSU`, SUSFS, BBG, and SUSFS+BBG combinations.
- `android-gs-raviole-6.1-android16`: manager, SUSFS, and BBG patches apply on
  the manifest source path `aosp`, but the current workflow target/path is not
  validated because this branch does not use `kernel/common` as the source path
  or expose a confirmed `//common:kernel_aarch64_dist` target.
- `android-gs-bluejay-6.1-android16`: same status as Raviole Android 16.
- `android-gs-akita-6.1-android16`: source sync failed for the manifest-mapped
  `aosp` and `build/kernel` refs during validation, so it is not in the Pixel
  release matrix.

Android 16 Pixel branches are omitted from the experimental release matrix until
their source path and Bazel target mapping are handled explicitly.

### Source Policy

- Single-build manual workflows can choose Google LTS, maintained, Pixel, or custom source modes:
  - `Build Kernel`
  - `Custom Kernel Build`
- Stable release matrix uses Google/AOSP LTS sources from `.github/matrix/release.json`.
- Experimental release matrix uses maintained GitHub `kernel/common` defaults from `.github/matrix/release_exp.json` or official Pixel manifests from `.github/matrix/release_pixel.json`. Custom experimental release runs reuse the maintained matrix shape with explicit `source_repo` / `source_ref`.

### SUSFS Note

SUSFS support is validated per manager and per maintained source tree, not just per kernel version.

- `5.10`, `6.1`, and `6.6` are validated on the maintained experimental source path for both `KernelSU` and `KowSU`.
- `KernelSU` and `KowSU` manager compatibility is still patch-source dependent, so custom source overrides can fail even when the default source path works.
- Experimental source replacement and SUSFS together may still break build output, Wi-Fi, vendor modules, root, KMI/KCFI, or boot.

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
- An experimental maintained-source or custom `kernel/common` tree diverges from the expected patch base.
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

Builds use the toolchain selected by the Android kernel source/build system. `compiler-version.txt` records the compiler visible after the build so users can compare it with `uname -a` or `/proc/version`.

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
| Experimental maintained-source build breaks boot or modules | Go back to the stable release matrix workflow or test a simpler maintained-source build first. |
| Root manager is not detected | Build the manager without SUSFS first, then test SUSFS separately. |
| SUSFS does not work | Confirm the same manager boots without SUSFS first. |
| BBG causes issues | Test the same build with BBG off, then compare logs. |
| Feature does not work | Rebuild with only that feature enabled. |
| Wrong kernel version | Rebuild with the GKI version used by your ROM/device. |

## Recovery Reminder

A successful build does not guarantee a successful boot. Keep recovery access ready before flashing.

## License

This project is licensed under the Mozilla Public License 2.0. See [LICENSE](LICENSE).
