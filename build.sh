#!/bin/bash
cd /tmp/ci
source "${CONFIG}"

cd /tmp/rom
ls && pwd
ccache -M 20G # It took only 6.4GB for mido
ccache -o compression=true # Will save times and data to download and upload ccache, also negligible performance issue
source build/envsetup.sh
export TARGET_KERNEL_CLANG_VERSION=proton
export CCACHE_DIR=/tmp/ccache
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
TARGET_USES_PREBUILT_KERNEL=false
lunch "${ROM_LUNCH_NAME}"_"${DEVICE_CODENAME}"-"${BUILD_TYPE}"
mka bacon -j18
