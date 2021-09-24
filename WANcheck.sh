#!/bin/bash

source /root/settings.ini

PINGTO1="google.com"
PINGTO2="8.8.8.8"
WAN1="eth0.5"
WAN2="eth0.1"

set_metric() {
  ifdown "$1"
  uci set network."$1".metric="$2"
  ifup "$1"
  sleep 1s
  echo "$1 metric set to $2, interface restarted."
}

restart_interface() {
  ifdown "$1"
  sleep 1s
  ifup "$1"
  echo "$1 interface restarted."
}

if ping -c5 -I $WAN1 $PINGTO1 > /dev/null;
then
  echo "WAN1 ping OK. $PINGTO1" | tee /root/settings/logs/WAN1
  if [ "$(uci get network.WAN1.metric)" = 20 ]
  then
    set_metric "WAN1" "0"
    $SENDMAIL "WAN1 restored" "WANcheck.sh, set_metric WAN1 0"
    $GETIP
  fi
else
  echo "WAN1 ping problem. $PINGTO1" | tee /root/settings/logs/WAN1
  #$SENDMAIL "WAN1 no ping to $PINGTO1" "WANcheck.sh, Interface $WAN1"
  if ping -c5 -I $WAN1 $PINGTO2 > /dev/null;
  then
    echo "WAN1 ping OK. $PINGTO2" | tee /root/settings/logs/WAN1
  else
    echo "WAN1 ping problem. $PINGTO2" | tee /root/settings/logs/WAN1
    $SENDMAIL "WAN1 no ping to $PINGTO2" "WANcheck.sh, Interface $WAN1"
    if [ "$(uci get network.WAN1.metric)" = 20 ]
    then
      restart_interface "WAN1"
    fi
    if [ "$(uci get network.WAN1.metric)" = 0 ]
    then
      set_metric "WAN1" "20"
      $SENDMAIL "Switched to WAN2" "WANcheck.sh, set_metric WAN1 20"
      $GETIP
    fi
  fi
fi

if ping -c5 -I $WAN2 $PINGTO1 > /dev/null;
then
  echo "WAN2 ping OK. $PINGTO1" | tee /root/settings/logs/WAN2
else
  echo "WAN2 ping problem. $PINGTO1" | tee /root/settings/logs/WAN2
  #$SENDMAIL "WAN2 no ping to $PINGTO1" "WANcheck.sh, Interface $WAN2"
  if ping -c5 -I $WAN2 $PINGTO2 > /dev/null;
  then
    echo "WAN2 ping OK. $PINGTO2" | tee /root/settings/logs/WAN2
  else
    echo "WAN2 ping problem. $PINGTO2" | tee /root/settings/logs/WAN2
    $SENDMAIL "WAN2 no ping to $PINGTO2" "WANcheck.sh, Interface $WAN2"
    restart_interface "WAN2"
  fi
fi

echo WAN1 metric is: "$(uci get network.WAN1.metric)"
echo WAN2 metric is: "$(uci get network.WAN2.metric)"
