#!/bin/bash
cd /tmp/ci
source "${CONFIG}"

retry_build() {
    cd /tmp/
    if [[ "${GIT_ORG_NAME}" == "none" ]]; then GIT_ORG_NAME="${GIT_USER_NAME}" ; fi
    git clone --depth=1 https://"${GIT_USER_NAME}":"${GIT_TOKEN}"@github.com/"${GIT_ORG_NAME}"/"${NAME_OF_THIS_REPOSITORY}" -b "${CURRENT_BRANCH_OF_THIS_REPO}" "${NAME_OF_THIS_REPOSITORY}"
    cd "${NAME_OF_THIS_REPOSITORY}"
    export $(tail -1 rty.txt)
    RETRY=$(expr $RETRY + 1)
    echo 'RETRY='$RETRY > rty.txt
    sed -i '$ d' download_ccache.sh
    echo 'CCACHE_RUN=0' >> download_ccache.sh
    git add download_ccache.sh rty.txt
    git commit -m "$ROM_NAME-$DEVICE_CODENAME: Rom Build Failed, Retrying Clean Build Retry $RETRY"
    git push -f https://"${GIT_USER_NAME}":"${GIT_TOKEN}"@github.com/"${GIT_ORG_NAME}"/"${NAME_OF_THIS_REPOSITORY}"
    exit 0
}
if [[ "$(< rty.txt)" -ge "4" ]]; then echo "Build Failed!" && exit 1; else retry_build ; fi
