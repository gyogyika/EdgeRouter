#!/bin/bash

source /root/settings.ini
source /root/utils

get_wan_status "WAN1"
WAN1_STATUS=$WAN_STATUS

get_wan_status "WAN2"
WAN2_STATUS=$WAN_STATUS

NOPINGS="invalid"
read -r NOPINGS < "/tmp/NOPINGS"

SPEEDTEST="invalid"
read -r SPEEDTEST < "/tmp/SPEEDTEST"

TIME=$(date +%s)

curl --get \
  --data-urlencode "set=$ROUTERNAME" \
  --data-urlencode "WAN1=$WAN1_STATUS" \
  --data-urlencode "WAN2=$WAN2_STATUS" \
  --data-urlencode "NOPINGS=$NOPINGS" \
  --data-urlencode "time=$TIME" \
  --data-urlencode "SPEEDTEST=$SPEEDTEST" \
"$STATUS_URL"
