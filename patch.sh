#!/bin/bash
source "${CONFIG}"

#sed -i s/'SELINUX_IGNORE_NEVERALLOWS := true'/'SELINUX_IGNORE_NEVERALLOWS := false'/g /tmp/rom/device/xiaomi/mt6768-common/BoardConfigCommon.mk
cd /tmp/rom/system/sepolicy; curl -s https://github.com/crdroidandroid/android_system_sepolicy/commit/9931973409baf7c69b492df8303d7d0278b2f5d2.patch | git am; cd -
prebuild_dialer(){
    cd /tmp/rom/device/xiaomi/mt6768-common
    echo '# Dialer
PRODUCT_PACKAGES += \
    Dialer' >> mt6768-common.mk
    mkdir -p Dialer
    echo 'LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := Dialer
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := Dialer.apk
LOCAL_CERTIFICATE := platform
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_DEX_PREOPT := false
LOCAL_PRODUCT_MODULE := true
include $(BUILD_PREBUILT)' >> Dialer/Android.mk
    curl -ksSLo Dialer/Dialer.apk https://gitlab.com/boxdumps/redmi_begonia_dump/-/raw/begonia-user-11-RP1A.200720.011-V12.5.5.0.RGGMIXM-release-keys-random-text-28640245401105/system/system/product/priv-app/Dialer/Dialer.apk
    rm -rf /tmp/rom/packages/apps/Dialer
    cd -
    
}
prebuild_dialer
