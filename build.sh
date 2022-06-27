#!/bin/bash
cd /tmp/ci
source "${CONFIG}"

cd /tmp/rom
ls && pwd

SECONDS=$(< /tmp/ci/seconds.txt)
timeout "$((6660 - $SECONDS))"s bash -c "source build/envsetup.sh
export TARGET_KERNEL_CLANG_VERSION=proton
export CCACHE_DIR=/tmp/ccache
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
export ccache -M 20G
#export ccache -o compression=true
TARGET_USES_PREBUILT_KERNEL=false
lunch "${ROM_LUNCH_NAME}"_"${DEVICE_CODENAME}"-"${BUILD_TYPE}"
mka bacon -j18" −−preserve−status; RESULT="$?"; echo $RESULT; if [[ "$RESULT" == "124" ]]; then exit 0; else exit $RESULT; fi
