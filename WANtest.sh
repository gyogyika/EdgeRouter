#!/bin/bash

source /root/settings.ini
source /root/pinginterface.sh
source /root/utils

echo "$WAN1NAME ISP: $ISP1NAME"
pinginterface "$WAN1NAME" "$ISP1NAME"
WAN1_INTERNET=$WAN_RESULT

echo "$WAN2NAME ISP: $ISP2NAME"
pinginterface "$WAN2NAME" "$ISP2NAME"
WAN2_INTERNET=$WAN_RESULT

if [[ "$WAN1_INTERNET" = "OFFLINE" && "$WAN2_INTERNET" = "ONLINE" ]]
then
  #echo WAN1 offline, WAN2 online.
  if [ "$(get_metric "$WAN1NAME")" = 0 ]
  then
    set_metric "$WAN1NAME" "20"
    set_metric "$WAN2NAME" "1"
    $SENDMAIL "Switched to $WAN2NAME" "set_metric $WAN1NAME 20, set_metric $WAN2NAME 1"
  fi
fi

if [[ $WAN1_INTERNET = "ONLINE" ]]
then
  #echo WAN1 online.
  if [ "$(get_metric "$WAN1NAME")" != 0 ]
  then
    set_metric "$WAN1NAME" "0"
    $SENDMAIL "$WAN1NAME restored, set_metric 0" "set_metric $WAN1NAME 0"
  fi

  if [ "$(get_metric "$WAN2NAME")" != 1 ]
  then
    set_metric "$WAN2NAME" "1"
    $SENDMAIL "$WAN2NAME set_metric 1" "set_metric $WAN2NAME 1"
  fi
fi

echo "$WAN1NAME INTERNET: $WAN1_INTERNET"
echo $WAN1NAME metric is: "$(get_metric "$WAN1NAME")"

echo "$WAN2NAME INTERNET: $WAN2_INTERNET"
echo $WAN2NAME metric is: "$(get_metric "$WAN2NAME")"

check_ip_change
