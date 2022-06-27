#!/bin/bash
cd /tmp/ci
source "${CONFIG}"
cd /tmp # Where to download cccahe
while [[ ! -f ccache.tar.gz ]]; do time aria2c "${CCACHE_INDEX_DOWNLOAD_URL}" -x16 -s50 ; done  # Using aria2c for speed haha, ccache will be at /tmp/ccache.tar.gz since my file name is ccache.tar.gz
time tar xf ccache.tar.gz  # Extract ccache so ci can use it
rm -rf ccache.tar.gz # Remove unnecessary downloaded file, it will speed up the upload ccache process
CCACHE_RUN=3
