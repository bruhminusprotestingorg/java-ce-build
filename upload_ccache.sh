#!/bin/bash
cd /tmp/ci
source "${CONFIG}"
com() 
{ 
    tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
}
cd /tmp/
time com ccache 1
mkdir -p ~/.config/rclone
echo "${rlslone_config}" > ~/.config/rclone/rclone.conf
time rclone --onedrive-chunk-size 250M --stats 5s copy ccache.tar.gz "${RCLONE_REMOTE_USED_FOR_CCACHE_STORAGE_NAME}":/"${CCACHE_STORAGE_DIRECTORY}"/ -P

rom_upload() {
    cp -R /tmp/rom/out/target/product/"${DEVICE_CODENAME}"/*zip /tmp/"${DEVICE_CODENAME}"-"${ROM_NAME}"-"${BUILD_TYPE}"-latest.zip
    cp -R /tmp/rom/out/target/product/"${DEVICE_CODENAME}"/"${DEVICE_CODENAME}".json /tmp/"${DEVICE_CODENAME}".json || echo "Skipping ${DEVICE_CODENAME}*json"
    time rclone --checkers=64 --onedrive-chunk-size 250M --stats 5s copy /tmp/"${DEVICE_CODENAME}"-"${ROM_NAME}"-"${BUILD_TYPE}"-latest.zip "${RCLONE_REMOTE_USED_FOR_CCACHE_STORAGE_NAME}":/"${TEMP_STORAGE_IN_CCACHE_DIRECTORY}"/ -P
    time rclone --checkers=64 --onedrive-chunk-size 250M --stats 5s copy /tmp/"${DEVICE_CODENAME}".json "${RCLONE_REMOTE_USED_FOR_CCACHE_STORAGE_NAME}":/"${TEMP_STORAGE_IN_CCACHE_DIRECTORY}"/ -P || echo "Skipping ${DEVICE_CODENAME}*json"
    time rclone --checkers=64 --onedrive-chunk-size 250M --stats 5s copy /tmp/rom/out/target/product/"${DEVICE_CODENAME}"/*zip "${RCLONE_REMOTE_USED_FOR_ROM_UPLOAD_NAME}":/"${ROM_STORAGE_DIRECTORY}"/ -P
    exit 0
}

increment_ccache_run() {
    cd /tmp/
    if [[ "${GIT_ORG_NAME}" == "none" ]]; then GIT_ORG_NAME="${GIT_USER_NAME}" ; fi
    git clone --depth=1 https://"${GIT_USER_NAME}":"${GIT_TOKEN}"@github.com/"${GIT_ORG_NAME}"/"${NAME_OF_THIS_REPOSITORY}" -b "${CURRENT_BRANCH_OF_THIS_REPO}" "${NAME_OF_THIS_REPOSITORY}"
    cd "${NAME_OF_THIS_REPOSITORY}"
    export $(tail -1 download_ccache.sh)
    CCACHE_RUN=$(expr $CCACHE_RUN + 1)
    sed -i '$ d' download_ccache.sh
    echo 'CCACHE_RUN'=$CCACHE_RUN >> download_ccache.sh
    git add download_ccache.sh
    git commit -m "$ROM_NAME-$DEVICE_CODENAME: build with ccache run $CCACHE_RUN"
    git push -f https://"${GIT_USER_NAME}":"${GIT_TOKEN}"@github.com/"${GIT_ORG_NAME}"/"${NAME_OF_THIS_REPOSITORY}"
    exit 0
}

if [[ -f "$(ls /tmp/rom/out/target/product/"${DEVICE_CODENAME}"/*zip)" ]]; then bash /tmp/ci/privatize_repo.sh && rom_upload; else bash /tmp/ci/publisize_repo.sh && increment_ccache_run; fi