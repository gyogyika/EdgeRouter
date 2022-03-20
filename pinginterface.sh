#!/bin/bash

source /root/colors.ini

pinginterface() {

  WAN=$1
  if [ $OPENWRTVER -gt 20 ]
  then
    WANIF=$(uci get network.$1.device)
  else
    WANIF=$(uci get network.$1.ifname)
  fi

  MESSAGE_LINE=""
  COUNTPING=0
  COUNTALL=0
  WAN_RESULT="none"

  if [ "$WANIF" != "none" ]
  then

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

    if [ $NOPING -gt 1 ]
    then
      MESSAGE_LINE="$MESSAGE_LINE""All pings: $COUNTALL"$'\n'"Success pings: $COUNTPING"$'\n'
      MESSAGE_LINE="$MESSAGE_LINE""Interface: $WAN"$'\n'"Device: $WANIF"
      $SENDMAIL "$WAN no pings: $NOPING" "$MESSAGE_LINE"
    fi

    if [ $COUNTPING -gt 0 ]
    then
      echo -e "$Color_GREENB$WAN Internet is online on interface $WANIF$Color_BLACK"
      WAN_RESULT="ONLINE"
    else
      echo -e "$Color_REDB$WAN Internet is offline on interface $WANIF$Color_BLACK"
      WAN_RESULT="OFFLINE"
    fi

  fi
}
