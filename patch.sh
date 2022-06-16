#!/bin/bash
source "${CONFIG}"

#sed -i s/'SELINUX_IGNORE_NEVERALLOWS := true'/'SELINUX_IGNORE_NEVERALLOWS := false'/g /tmp/rom/device/xiaomi/mt6768-common/BoardConfigCommon.mk
cd /tmp/rom/system/sepolicy; curl -s https://github.com/crdroidandroid/android_system_sepolicy/commit/9931973409baf7c69b492df8303d7d0278b2f5d2.patch | git am; cd -