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
export RELAX_USES_LIBRARY_CHECK=true
export PRODUCT_BROKEN_VERIFY_USES_LIBRARIES=true
ccache -M 20G
ccache -o compression=true
TARGET_USES_PREBUILT_KERNEL=false
lunch "${ROM_LUNCH_NAME}"_"${DEVICE_CODENAME}"-"${BUILD_TYPE}"
mka bacon -j18" −−preserve−status; RESULT="$?"; echo $RESULT; if [[ "$RESULT" == "124" ]]; then exit 0; elif [[ "$RESULT" == "1" ]]; then bash /tmp/ci/retry_cleanbuild.sh ; else exit $RESULT; fi
