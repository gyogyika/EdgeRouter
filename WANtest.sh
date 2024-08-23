#!/bin/bash

source /tmp/root/settings.ini
source /tmp/root/pinginterface.sh
source /tmp/root/utils

echo "$WAN1NAME ISP: $WAN1ISPNAME"
echo "$WAN1NAME interface: $WAN1IF"
pinginterface "WAN1" "$WAN1NAME" "$WAN1ISPNAME" "$WAN1IF"
WAN1_INTERNET=$WAN_RESULT

echo "$WAN2NAME ISP: $WAN2ISPNAME"
echo "$WAN2NAME interface: $WAN2IF"
pinginterface "WAN2" "$WAN2NAME" "$WAN2ISPNAME" "$WAN2IF"
WAN2_INTERNET=$WAN_RESULT

echo "$WAN3NAME ISP: $WAN3ISPNAME"
echo "$WAN3NAME interface: $WAN3IF"
pinginterface "WAN3" "$WAN3NAME" "$WAN3ISPNAME" "$WAN3IF"
WAN3_INTERNET=$WAN_RESULT

if [[ "$WAN1_INTERNET" = "NONE" ]]
then
  WAN1_INTERNET="OFFLINE"
fi

if [[ "$WAN2_INTERNET" = "NONE" ]]
then
  WAN2_INTERNET="OFFLINE"
fi

if [[ "$WAN3_INTERNET" = "NONE" ]]
then
  WAN3_INTERNET="OFFLINE"
fi

if [[ "$WAN1_INTERNET" = "OFFLINE" && "$WAN2_INTERNET" = "ONLINE" ]]
then
  #echo WAN1 offline, WAN2 online.
  if [ "$(get_metric "$WAN1NAME")" != 20 ] || [ "$(get_metric "$WAN2NAME")" != 1 ]
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
  if [ "$(get_metric "$WAN1NAME")" != 20 ] || [ "$(get_metric "$WAN2NAME")" != 30 ]
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
