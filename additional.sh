#!/bin/bash
cd /tmp/ci
source "${CONFIG}"
curl -ksSLo ~/.gitcookies "${GIT_COOKIES_RAW_GIST}"
chmod 0600 ~/.gitcookies
git config --global http.cookiefile ~/.gitcookies
sudo touch /etc/mtab; sudo chmod 777 /etc/mtab
git config --global http.sslverify false
export GIT_SSL_NO_VERIFY=1
echo Success!