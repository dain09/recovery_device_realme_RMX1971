#
# Copyright (C) 2019 The TwrpBuilder Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_PATH := device/realme/RMX1971

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo385

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := kryo385

ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Platform
TARGET_BOARD_PLATFORM := sdm710
TARGET_BOOTLOADER_BOARD_NAME := sdm710
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# fstab
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab

# Kernel
BOARD_KERNEL_CMDLINE := \
    console=ttyMSM0,115200n8 \
    earlycon=msm_geni_serial,0xA90000 \
    androidboot.hardware=qcom \
    androidboot.console=ttyMSM0 \
    androidboot.boot_devices=soc/1d84000.ufshc \
    video=vfb:640x400,bpp=32,memsize=3072000 \
    msm_rtb.filter=0x237 \
    ehci-hcd.park=3 \
    lpm_levels.sleep_disabled=1 \
    service_locator.enable=1 \
    androidboot.configfs=true \
    androidboot.usbcontroller=a600000.dwc3 \
    swiotlb=1 \
    loop.max_part=7 \
    printk.devkmsg=on \
    kpti=off

BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_NO_KERNEL := false
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset 0x01000000 --tags_offset 0x00000100 --header_version 1
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz-dtb
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 5435817984
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 55141412864
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE ?= f2fs
BOARD_VENDORIMAGE_PARTITION_SIZE := 1660944384
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USES_METADATA_PARTITION := true

TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_USE_EXT4 := true

# Workaround for error copying vendor files to recovery ramdisk
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_SUPPRESS_SECURE_ERASE := true
TARGET_NO_RECOVERY := false

# Recovery Compression
BOARD_RAMDISK_USE_LZ4 := true
TARGET_USES_MKE2FS := true

# Crypto (Android.mk forces FBE + metadata_decrypt when TW_INCLUDE_CRYPTO is set)
TW_INCLUDE_CRYPTO := true
TW_USE_FSCRYPT_POLICY := 1
BOARD_USES_QCOM_FBE_DECRYPTION := true

# Hack: prevent anti rollback
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2127-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Extras
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_REPACKTOOLS := true

# TWRP specific build flags
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.0/lun.%d/file
TW_THEME := portrait_hdpi
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_DEFAULT_BRIGHTNESS := 230
TW_MAX_BRIGHTNESS := 1023
TW_NO_SCREEN_BLANK := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXTRA_LANGUAGES := true
TW_USE_LEDS_HAPTICS := false
TW_HAS_EDL_MODE := true
TW_INCLUDE_NTFS_3G := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_NO_EXFAT_FUSE := true
TW_SKIP_COMPATIBILITY_CHECK := true
TW_OZIP_DECRYPT_KEY :=  1c4c1ea3a12531ae491b21bb31613c11
TW_QCOM_ATS_OFFSET := 1621580431500

# ── Recommended flags (from Android.mk audit) ──────────────────────────

# HIGH: Pass BOARD_BOOT_HEADER_VERSION so -DBOARD_BOOT_HEADER_VERSION=1
# reaches CFLAGS; affects boot image header parsing in recovery.
BOARD_BOOT_HEADER_VERSION := 1

# HIGH: Issue BLKDISCARD on wipe/format. UFS 2.1 on sdm710 benefits from
# explicit trim — improves flash longevity and subsequent write speed.
TW_ENABLE_BLKDISCARD := true

# HIGH: Exclude APEX container handling from recovery build. APEX has no
# function in recovery; this eliminates 30+ "no matching fstab entry for
# loop" log lines and shrinks the binary.
TW_EXCLUDE_APEX := true

# MEDIUM: Skip redundant /system bind mount on SAR devices. System is
# already mounted at /system_root; bind to /system adds no value.
TW_NO_BIND_SYSTEM := true

# MEDIUM: Skip parsing stock /vendor/etc/fstab.qcom as additional fstab.
# Prevents vendor fs_mgr flags like "latemount" from bleeding into TWRP's
# partition table and producing "Unhandled flag" warnings.
TW_SKIP_ADDITIONAL_FSTAB := true

# MEDIUM: Enable fastbootd inside recovery. Allows "adb reboot fastboot"
# to enter fastbootd for flashing system/vendor images via fastboot.
TW_INCLUDE_FASTBOOTD := true

# LOW: Explicitly declare SAR — gates -DBOARD_BUILD_SYSTEM_ROOT_IMAGE in
# the Android.mk. Already implicit via OrangeFox config but should be
# explicit in the device tree.
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

# TWRP Debug Flags
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
TW_RECOVERY_ADDITIONAL_RELINK_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_RECOVERY_ADD_HASH_FOOTER_ARGS += \
    --prop com.android.build.recovery.fingerprint:$(BUILD_FINGERPRINT_FROM_FILE) \
    --prop com.android.build.boot.os_version:$(PLATFORM_VERSION) \
    --prop com.android.build.boot.security_patch:$(PLATFORM_SECURITY_PATCH)
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Include python, for ABX conversion
TW_INCLUDE_PYTHON := true
