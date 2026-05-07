# SUSFS upstream validation

Last validated: 2026-05-07

Official upstream checked: `https://gitlab.com/simonpunk/susfs4ksu.git`

The requested GitHub namespace did not expose a fetchable repository during
validation; the public upstream used by mirrors points at the GitLab repository
above.

## Upstream refs

| Local patch directory | Upstream branch | Upstream commit |
| --- | --- | --- |
| `gki-android12-5.10` | `gki-android12-5.10` | `4a309bd1735c925319f488986364e3946f3a2cea` |
| `gki-android14-6.1` | `gki-android14-6.1` | `9da70b0cd04ed34a745bbbdffeb61203f46e2a8d` |
| `gki-android15-6.6` | `gki-android15-6.6` | `fdc1fa7e99bb605c6836c3b75ffae7a4bf51fdc4` |

Each checked upstream branch was at:

`KernelSU: Remove the unused deprecated residual devpts hook`

## File comparison

For 5.10, 6.1, and 6.6, these local files are identical to the upstream
branch-matched files:

- `fs/susfs.c`
- `include/linux/susfs.h`
- `include/linux/susfs_def.h`

The local integration patches intentionally differ from upstream:

- `50_add_susfs_in_*.patch`
- `KernelSU/10_enable_susfs_for_ksu.patch`

The core patch differences are source-layout/context refreshes for the source
trees supported by this workflow. The local core patches keep the required
SUSFS integration hunks and include the target-layout `fs/devpts/inode.c`
integration used by the supported Google LTS and maintained sources.

The manager patch differences are limited to applying the same SUSFS enablement
to the workflow-pinned KernelSU and KowSU source layouts. They are not sed,
pre/post, or shim workarounds.

No SUSFS source/header logic was dropped from the local copy during this
validation.

## Apply validation

Validated with `git apply --check` before applying each SUSFS source patch and
manager patch.

| Kernel | Source | Manager | Result |
| --- | --- | --- | --- |
| 5.10 | Google LTS | KernelSU | PASS |
| 5.10 | Google LTS | KowSU | PASS |
| 5.10 | maintained | KernelSU | PASS |
| 5.10 | maintained | KowSU | PASS |
| 6.1 | Google LTS | KernelSU | PASS |
| 6.1 | Google LTS | KowSU | PASS |
| 6.1 | maintained | KernelSU | PASS |
| 6.1 | maintained | KowSU | PASS |
| 6.6 | Google LTS | KernelSU | PASS |
| 6.6 | Google LTS | KowSU | PASS |
| 6.6 | maintained | KernelSU | PASS |
| 6.6 | maintained | KowSU | PASS |

## Pixel source validation

Pixel source profile validation uses official Google Pixel kernel manifests and
the same workflow patch order: sync source, initialize the selected manager,
check and apply SUSFS, check and apply BBG, then generate config.

| Pixel branch | Source root | KernelSU + SUSFS | KowSU + SUSFS | Matrix status |
| --- | --- | --- | --- | --- |
| `android14-gs-pixel-6.1` | `kernel/common` | PASS | PASS | SUSFS variants retained |
| `android-gs-raviole-6.1-android16` | `kernel/aosp` | FAIL: core SUSFS patch does not apply | FAIL: core SUSFS patch does not apply | SUSFS variants omitted |
| `android-gs-bluejay-6.1-android16` | `kernel/aosp` | FAIL: core SUSFS patch does not apply | FAIL: core SUSFS patch does not apply | SUSFS variants omitted |
| `android-gs-akita-6.1-android16` | unresolved | unsupported/unvalidated | unsupported/unvalidated | omitted; manifest refs failed during sync |

Unsupported Pixel SUSFS variants are intentionally omitted from
`.github/matrix/release_pixel.json`. Non-SUSFS manager and BBG variants remain
only where they were separately validated.
