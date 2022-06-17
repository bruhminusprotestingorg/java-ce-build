#!/bin/bash
cd /tmp/ci
source "${CONFIG}"

mkdir -p /tmp/rom # Where to sync source
cd /tmp/rom

git config --global user.email "${GIT_CONFIG_EMAIL}"
git config --global user.name "${GIT_CONFIG_NAME}"
git config --global http.postBuffer 524288000

# sync rom
repo init -q --no-repo-verify --depth=1 -u "${ROM_MANIFEST_LINK}" -b "${ROM_BRANCH}" -g default,-mips,-darwin,-notdefault
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j30 || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -q -j8
git clone --depth=2 --single-branch https://github.com/Redmi-MT6768/android_kernel_xiaomi_mt6768 -b eleven kernel/xiaomi/mt6768
git clone --depth=1 --single-branch https://github.com/Redmi-MT6768/android_device_xiaomi_merlinx -b lineage-18.1 device/xiaomi/merlinx
git clone --depth=1 --single-branch https://github.com/Redmi-MT6768/android_device_xiaomi_mt6768-common -b lineage-18.1 device/xiaomi/mt6768-common
git clone --depth=1 --single-branch https://github.com/Redmi-MT6768/android_vendor_xiaomi_merlinx -b eleven vendor/xiaomi/merlinx
#git clone --depth=1 --single-branch https://github.com/Redmi-MT6768/android_vendor_xiaomi_mt6768-ims vendor/xiaomi/mt6768-ims
git clone --depth=1 --single-branch https://github.com/PixelExperience/device_mediatek_sepolicy_vndr.git -b eleven device/mediatek/sepolicy_vndr
#git clone --depth=1 --single-branch https://github.com/kdrag0n/proton-clang.git prebuilts/clang/host/linux-x86/clang-proton
while [[ ! -f prebuilts/clang/host/linux-x86/clang-proton.tar.gz ]]; do time aria2c https://mirror.buildbot.workers.dev/0:/clang-proton.tar.gz -d prebuilts/clang/host/linux-x86/ -x16 -s50 ; done  # Using aria2c instead of git clone, as it saves approximately 2min which is VERY precious in this case, It could make or break upload.
time tar xf prebuilts/clang/host/linux-x86/clang-proton.tar.gz --directory prebuilts/clang/host/linux-x86/; rm -rf prebuilts/clang/host/linux-x86/clang-proton.tar.gz
ls prebuilts/clang/host/linux-x86/