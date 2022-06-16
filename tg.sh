#!/bin/bash
source "${CONFIG}"
if [[ -f "$(ls /tmp/rom/out/target/product/"${DEVICE_CODENAME}"/*zip)" ]]; then echo 'Sending Telegram Message'; else echo 'Build Not Completed, skipping Telegram Message' && exit 0; fi
cd /tmp/rom/out/target/product/"${DEVICE_CODENAME}"/
ZIPNAME="$(ls *zip)"
DOWNLOAD_LINK="${DOWNLOAD_LINK_WITHOUT_FILENAME}"/"${ZIPNAME}"
DIRECT_DOWNLOAD_LINK="${DIRECT_DOWNLOAD_LINK_INDEX}"/"${ZIPNAME}"
echo "<b>Rom: ${ROM_NAME}</b>" > tg.html
echo "<b>Device Codename:</b> ${DEVICE_CODENAME}" >> tg.html
echo "<b>Temporary Download Link: </b><a href=\"${TEMP_DOWNLOAD_LINK}\">Here</a>" >> tg.html
echo "<b>Download Link: </b><a href=\"${DOWNLOAD_LINK}\">Here</a>" >> tg.html
echo "<b>Direct Download Link: </b><a href=\"${DIRECT_DOWNLOAD_LINK}\">Here</a>" >> tg.html
TEXT=$(< tg.html)
curl -s "https://api.telegram.org/bot${TG_TOKEN}/sendmessage" --data "text=${TEXT}&chat_id=${TELEGRAM_CHANNEL_ID}&parse_mode=HTML&disable_web_page_preview=True"
sleep 10s
