#!/bin/bash

source /root/colors.ini

pinginterface() {

if [ "$1" != "none" ]
then
  WAN=$1
  ISP=$2
  WAN_IP=$(get_interface_ip "$WAN")
  WAN_PROTO=$(get_interface_proto "$WAN")
  echo "$WAN IP: $WAN_IP $WAN_PROTO"
  get_wan_status "$WAN"
  WAN_PREV_STATUS=$WAN_STATUS

  if [ "$WAN_IP" = "" ]
  then
    echo "$WAN" IP not assigned. # WAN_PREV_STATUS is NONE

    if [ "$WAN_PREV_STATUS" = "OFFLINE" ]
    then
      $SENDMAIL "$WAN IP not assigned" "ISP: $ISP, proto: $WAN_PROTO"
    fi

    set_wan_status "$WAN" "NONE"
    WAN_RESULT="NONE"
  fi

  if [ "$WAN_IP" != "" ]

  then

    if [ "$WAN_PREV_STATUS" = "NONE" ]
    then
      $SENDMAIL "$WAN IP assigned: $WAN_IP" "ISP: $ISP, proto: $WAN_PROTO"
    fi

    if [ "$OPENWRTVER" -gt 20 ]
    then
      WANIF=$(uci get network."$WAN".device)
    else
      WANIF=$(uci get network."$WAN".ifname)
    fi

    MESSAGE_LINE=""
    COUNTPING=0
    COUNTALL=0

    while read -r PINGTOLINE; do

      PING=$(echo "$PINGTOLINE" | awk '{print $1}')

      if ! [[ $PING == "#"* || $PINGTOLINE == "" ]]
      then

        COUNTALL=$((COUNTALL+1))

        if ping -c1 -W1 -I "$WANIF" "$PING" > /dev/null
        then
          echo "$WAN ping OK. $PING"
          MESSAGE_LINE="$MESSAGE_LINE$PINGTOLINE - OK"$'\n'
          COUNTPING=$((COUNTPING+1))
        else
          echo -e "$Color_REDB$WAN ping problem. $PING$Color_BLACK"
          MESSAGE_LINE="$MESSAGE_LINE$PINGTOLINE - NO PING"$'\n'
        fi
      fi

    done < /root/pinginterface

    # for testing
    #echo "Success pings:" $COUNTPING
    #echo "All pings:" $COUNTALL
    NOPING=$((COUNTALL-COUNTPING))
    #echo "$WAN no pings: "$NOPING

    if [ $NOPING -gt 7 ]
    then
      MESSAGE_LINE="$MESSAGE_LINE""All pings: $COUNTALL"$'\n'"Success pings: $COUNTPING"$'\n'
      MESSAGE_LINE="$MESSAGE_LINE""Interface: $WAN"$'\n'"Device: $WANIF"
      $SENDMAIL "$WAN no pings: $NOPING, $WAN IP: $WAN_IP $WAN_PROTO" "$MESSAGE_LINE"
    fi

    if [ $COUNTPING -gt 0 ]
    then
      echo -e "$Color_GREENB$WAN Internet is online on interface $WANIF$Color_BLACK"
      set_wan_status "$WAN" "ONLINE"
      WAN_RESULT="ONLINE"
      if [ "$WAN_PREV_STATUS" = "OFFLINE" ] || [ "$WAN_PREV_STATUS" = "NONE" ]
      then
        $SENDMAIL "$WAN restored to online: $WAN_IP" "ISP: $ISP, proto: $WAN_PROTO"
      fi
    else
      echo -e "$Color_REDB$WAN Internet is offline on interface $WANIF$Color_BLACK"
      set_wan_status "$WAN" "OFFLINE"
      WAN_RESULT="OFFLINE"
      ifdown "$WAN"
      sleep 1s
      ifup "$WAN"
      echo "Interface $WAN restarted."
    fi

  fi
else
  WAN_RESULT="NONE"
fi
echo 
}
