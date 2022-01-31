#!/bin/bash

source /root/settings.ini
source /root/pingto.sh
source /root/utils

pingto "WAN1" "$WAN1"
pingto "WAN2" "$WAN2"

if [[ "$WAN1_INTERNET" = "OFFLINE" && "$WAN2_INTERNET" = "ONLINE" ]]
then
  #echo WAN1 offline, WAN2 online.
  if [ "$(get_metric "WAN1")" = 0 ]
  then
    set_metric "WAN1" "20"
    set_metric "WAN2" "1"
    $SENDMAIL "Switched to WAN2" "set_metric WAN1 20"
  fi
fi

if [[ $WAN1_INTERNET = "ONLINE" ]]
then
  #echo WAN1 online.
  if [ "$(get_metric "WAN1")" != 0 ]
  then
    set_metric "WAN1" "0"
    set_metric "WAN2" "1"
    $SENDMAIL "WAN1 restored" "set_metric WAN1 0"
  fi
fi

echo WAN1 metric is: "$(get_metric "WAN1")"
echo WAN2 metric is: "$(get_metric "WAN2")"

echo "WAN1 INTERNET: $WAN1_INTERNET"
echo "WAN2 INTERNET: $WAN2_INTERNET"

check_ip_change
