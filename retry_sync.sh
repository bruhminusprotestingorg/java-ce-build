#!/bin/bash
cd /tmp/ci
source "${CONFIG}"

increment_ccache_run() {
    cd /tmp/
    if [[ "${GIT_ORG_NAME}" == "none" ]]; then GIT_ORG_NAME="${GIT_USER_NAME}" ; fi
    git clone --depth=1 https://"${GIT_USER_NAME}":"${GIT_TOKEN}"@github.com/"${GIT_ORG_NAME}"/"${NAME_OF_THIS_REPOSITORY}" -b "${CURRENT_BRANCH_OF_THIS_REPO}" "${NAME_OF_THIS_REPOSITORY}"
    cd "${NAME_OF_THIS_REPOSITORY}"
    echo $RANDOM$RANDOM$RANDOM > dummy.txt
    git add dummy.txt
    git commit -m "$ROM_NAME-$DEVICE_CODENAME: Sync Failed, Retrying!"
    git push -f https://"${GIT_USER_NAME}":"${GIT_TOKEN}"@github.com/"${GIT_ORG_NAME}"/"${NAME_OF_THIS_REPOSITORY}"
    exit 0
}
increment_ccache_run