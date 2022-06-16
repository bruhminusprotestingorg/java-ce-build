#!/bin/bash
cd /tmp/ci
source "${CONFIG}"
curl -X PATCH -H "Accept: application/vnd.github.nebula-preview+json" -H "Authorization: token $GIT_TOKEN" https://api.github.com/repos/bruhminusprotestingorg/java-ce-build -d '{"visibility":"private"}'