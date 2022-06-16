#!/bin/bash
cd /tmp/ci
source "${CONFIG}"
curl -X PATCH -H "Accept: application/vnd.github.nebula-preview+json" -H "Authorization: token $GIT_TOKEN" https://api.github.com/repos/"${GIT_ORG_NAME}"/"${NAME_OF_THIS_REPOSITORY}" -d '{"visibility":"public"}'
sleep 1m