<!-- SPDX-License-Identifier: MPL-2.0 -->

# CoreShift-GKI

Build and flash custom Android GKI LTS kernels with GitHub Actions.

CoreShift-GKI gives Android power users a simple way to build a flashable
custom GKI kernel with optional root, container, SUSFS, and security features.
You pick the options in GitHub Actions, wait for the build, then download the
generated kernel package.

## What This Is

CoreShift-GKI is a GitHub Actions-based custom Android GKI LTS kernel builder.

It is meant for users who want a custom kernel without setting up a full Android
kernel build environment on their own computer.

## Who This Is For

This repo is for:

- Android power users
- Root users
- Custom ROM users
- Users who want to test a custom GKI kernel
- Users who understand how to recover from a bad kernel flash

CoreShift-GKI cannot guarantee that every build will boot on every device or
ROM.

## Supported Kernels

| Android GKI family | Kernel version |
| --- | --- |
| Android 12 GKI | `5.10` |
| Android 14 GKI | `6.1` |
| Android 15 GKI | `6.6` |

Your selected GKI version must match your device and ROM family.

## Supported Root Manager Choices

| Choice | Meaning |
| --- | --- |
| `Vanilla` | No root manager |
| `KernelSU` | KernelSU manager support |
| `KernelSU-Next` | KernelSU-Next manager support |
| `KowSU` | KowSU manager support |
| `ResukiSU` | ResukiSU manager support |
| `Rissu` | Rissu manager support |
| `Wild_KSU` | Wild_KSU manager support |

## Quick Start

1. Fork this repo.
2. Open the **Actions** tab in your fork.
3. Run **Build Kernel (GKI LTS)**.
4. Pick your kernel version and options.
5. Wait for the release to finish.
6. Download the flashable AnyKernel zip.
7. Flash only if you know how to recover your device.

## Recommended Choices

| Goal | Recommended settings |
| --- | --- |
| First build | `Vanilla`, thin LTO, all advanced options off |
| Root build | Choose one manager, leave SUSFS off first |
| Container build | Enable `container_core` and `mount_filesystems` first |
| Advanced build | Try SUSFS or Baseband Guard only after a basic build boots |

Start small. Confirm a basic build boots before adding advanced features.

## Option Guide

| Option | Plain-language meaning |
| --- | --- |
| `lto` | Build optimization. `thin` is recommended. |
| `ikconfig` | Lets you check the running kernel config from Android. |
| `container_core` | Basic Linux container support. |
| `container_ipc` | Extra IPC features for containers. More experimental. |
| `mount_filesystems` | OverlayFS, FUSE, and tmpfs helpers. |
| `container_networking` | Bridge, NAT, and VETH networking. Advanced. |
| `fq_codel_features` | Extra network queue options. |
| `performance_features` | Performance-oriented kernel options. |
| `susfs` | Root hiding and spoofing support. Advanced and risky. |
| `baseband_guard` | Extra protection feature. Advanced. |
| `debug_features` | Troubleshooting features. Not needed for normal use. |
| `heavy_debug_features` | Heavy troubleshooting options. Not for daily use. |
| `strict_config` | Fails the build if requested options are missing. |

## Safety First

Custom kernels can bootloop.

Before flashing:

- Back up your current `boot`, `init_boot`, and `vendor_boot` images when your
  device uses them.
- Keep a known-good kernel or ROM package ready.
- Know how to use recovery or fastboot.
- Do not test advanced options first.
- Do not flash a kernel built for the wrong GKI version.

Flash at your own risk. This project helps build kernels, but it cannot make a
kernel universally safe or compatible.

## Compatibility Notes

Your device, ROM, Android version, and GKI kernel family must match. A kernel
that works on one ROM or device may fail on another.

If you are unsure which GKI version your device uses, check your ROM or device
documentation before building.

SUSFS and Baseband Guard are advanced options. Build and boot a basic kernel
first, then test these features separately.

## Outputs

Each successful run publishes a release with:

- A flashable AnyKernel zip
- A raw kernel `Image`

Most users should flash the AnyKernel zip, not the raw `Image`.

## Troubleshooting

| Problem | What to try |
| --- | --- |
| Build failed | Re-run with fewer options. Start from `Vanilla` and thin LTO. |
| Device bootloops | Restore boot images or flash a known-good kernel. |
| Full LTO build was killed | Use thin LTO. Full LTO needs much more memory. |
| Feature does not work | Rebuild with only that feature enabled. |
| Wrong kernel version | Rebuild with the GKI version for your ROM/device. |
| Root manager problem | Try a basic manager build first, without SUSFS. |

## License

This project is licensed under the Mozilla Public License 2.0. See
[LICENSE](LICENSE).
