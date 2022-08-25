#!/bin/bash

source /root/settings.ini
source /root/pinginterface.sh
source /root/utils

echo "$WAN1NAME ISP 1: $ISP1NAME"
pinginterface "WAN1" "$WAN1NAME" "$ISP1NAME"
WAN1_INTERNET=$WAN_RESULT

echo "$WAN2NAME ISP 2: $ISP2NAME"
pinginterface "WAN2" "$WAN2NAME" "$ISP2NAME"
WAN2_INTERNET=$WAN_RESULT

echo "$WAN3NAME ISP 3: $ISP3NAME"
pinginterface "WAN3" "$WAN3NAME" "$ISP3NAME"
WAN3_INTERNET=$WAN_RESULT

if [[ "$WAN1_INTERNET" = "OFFLINE" && "$WAN2_INTERNET" = "ONLINE" ]]
then
  #echo WAN1 offline, WAN2 online.
  if [ "$(get_metric "$WAN1NAME")" = 0 ]
  then
    set_metric "$WAN1NAME" "20"
    set_metric "$WAN2NAME" "1"
    set_metric "$WAN3NAME" "2"
    $SENDMAIL "Switched to $WAN2NAME" "set_metric $WAN1NAME 20, set_metric $WAN2NAME 1 set_metric $WAN3NAME 2"
  fi
fi

if [[ "$WAN1_INTERNET" = "OFFLINE" && "$WAN2_INTERNET" = "OFFLINE" && "$WAN3_INTERNET" = "ONLINE" ]]
then
  #echo WAN1 offline, WAN2 offline, WAN3 online.
  if [ "$(get_metric "$WAN1NAME")" = 0 ] || [ "$(get_metric "$WAN2NAME")" = 1 ]
  then
    set_metric "$WAN1NAME" "20"
    set_metric "$WAN2NAME" "30"
    set_metric "$WAN3NAME" "2"
    $SENDMAIL "Switched to $WAN3NAME" "set_metric $WAN1NAME 20, set_metric $WAN2NAME 30, set_metric $WAN3NAME 2"
  fi
fi

if [[ $WAN1_INTERNET = "ONLINE" ]]
then
  #echo WAN1 online.
  if [ "$(get_metric "$WAN1NAME")" != 0 ]
  then
    set_metric "$WAN1NAME" "0"
    $SENDMAIL "$WAN1NAME set_metric 0" "set_metric $WAN1NAME 0"
  fi

  if [ "$WAN2NAME" != "none" ]
  then
    if [ "$(get_metric "$WAN2NAME")" != 1 ]
    then
      set_metric "$WAN2NAME" "1"
      $SENDMAIL "$WAN2NAME set_metric 1" "set_metric $WAN2NAME 1"
    fi
  fi

  if [ "$WAN3NAME" != "none" ]
  then
    if [ "$(get_metric "$WAN3NAME")" != 2 ]
    then
      set_metric "$WAN3NAME" "2"
      $SENDMAIL "$WAN3NAME set_metric 2" "set_metric $WAN3NAME 2"
    fi
  fi
fi

echo "WAN1 INTERNET: $WAN1_INTERNET"
echo "$WAN1NAME" metric is: "$(get_metric "$WAN1NAME")"

echo "WAN2 INTERNET: $WAN2_INTERNET"
echo "$WAN2NAME" metric is: "$(get_metric "$WAN2NAME")"

echo "WAN3 INTERNET: $WAN3_INTERNET"
echo "$WAN3NAME" metric is: "$(get_metric "$WAN3NAME")"

check_ip_change
