### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
properties() { "
kernel.string=
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
"; }

### AnyKernel install

BLOCK=boot
IS_SLOT_DEVICE=auto
RAMDISK_COMPRESSION=auto
PATCH_VBMETA_FLAG=auto

. tools/ak3-core.sh

split_boot

# ===== Kernel Version =====
KERNEL_VER="$(strings "${AKHOME}/Image" 2>/dev/null | grep -E -m1 'Linux version.*#' | awk '{print $3}')"
[ -z "$KERNEL_VER" ] && KERNEL_VER="unknown"

# ===== UI =====
ui_print " "
ui_print "========================================"
ui_print "         CoreShift GKI Kernel"
ui_print "========================================"
ui_print " Android 12 | Linux 5.10 Series"
ui_print " Maintainer  : Diky_I"
ui_print " Kernel Ver  : ${KERNEL_VER}"
ui_print " Slot Device : A/B"
ui_print "----------------------------------------"
ui_print " Flashing boot image..."
ui_print " "

flash_boot

ui_print " "
ui_print "----------------------------------------"
ui_print " Flash completed successfully."
ui_print "========================================"
ui_print " "
