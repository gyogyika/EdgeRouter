#!/bin/sh

SENDMAIL="/root/send-mail.sh"
PINGTO1="google.com"
PINGTO2="8.8.8.8"
WAN1="eth0.5"
WAN2="eth0.1"

set_metric() {
  ifdown "$1"
  uci set network."$1".metric="$2"
  ifup "$1"
  echo "$1 metric set to $2, interface restarted."
}

restart_interface() {
  ifdown "$1"
  sleep 1s
  ifup "$1"
  echo "$1 interface restarted."
}

ping -c1 -I $WAN1 $PINGTO1 > /dev/null
if [ $? -ne 0 ]
then
  echo "WAN1 ping problem. $PINGTO1" | tee /root/WAN1
  $SENDMAIL "WAN1 no ping to $PINGTO1" "WANcheck.sh, Interface $WAN1"
  ping -c1 -I $WAN1 $PINGTO2 > /dev/null
  if [ $? -ne 0 ]
  then
    echo "WAN1 ping problem. $PINGTO2" | tee /root/WAN1
    $SENDMAIL "WAN1 no ping to $PINGTO2" "WANcheck.sh, Interface $WAN1"
    if [ "$(uci get network.WAN1.metric)" = 20 ]
    then
      restart_interface "WAN1"
    fi
    if [ "$(uci get network.WAN1.metric)" = 0 ]
    then
      set_metric "WAN1" "20"
    fi
  else
    echo "WAN1 ping OK. $PINGTO2" | tee /root/WAN1
  fi
else
  echo "WAN1 ping OK. $PINGTO1" | tee /root/WAN1
  if [ "$(uci get network.WAN1.metric)" = 20 ]
  then
    set_metric "WAN1" "0"
    $SENDMAIL "WAN1 restored" "WANcheck.sh, Interface $WAN1"
  fi
fi

ping -c1 -I $WAN2 $PINGTO1 > /dev/null
if [ $? -ne 0 ]
then
  echo "WAN2 ping problem. $PINGTO1" | tee /root/WAN2
  $SENDMAIL "WAN2 no ping to $PINGTO1" "WANcheck.sh, Interface $WAN2"
  ping -c1 -I $WAN2 $PINGTO2 > /dev/null
  if [ $? -ne 0 ]
  then
    echo "WAN2 ping problem. $PINGTO2" | tee /root/WAN2
    $SENDMAIL "WAN2 no ping to $PINGTO2" "WANcheck.sh, Interface $WAN2"
    restart_interface "WAN2"
  else
    echo "WAN2 ping OK. $PINGTO2" | tee /root/WAN2
  fi
else
  echo "WAN2 ping OK. $PINGTO1" | tee /root/WAN2
fi

echo WAN1 metric is: "$(uci get network.WAN1.metric)"
echo WAN2 metric is: "$(uci get network.WAN2.metric)"
