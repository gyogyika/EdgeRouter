#!/bin/bash

source /root/colors.ini

pingto() {

  WAN=$1
  WANIF=$2
  MESSAGE_LINE=""
  COUNTPING=0
  COUNTALL=0

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
          MESSAGE_LINE="$MESSAGE_LINE$PINGTOLINE - ping OK"$'\n'
          COUNTPING=$((COUNTPING+1))
        else
          echo -e "$Color_REDB$WAN ping problem. $PING$Color_BLACK"
          MESSAGE_LINE="$MESSAGE_LINE$PINGTOLINE - no ping"$'\n'
        fi
      fi

    done < "$PINGTOFILE"

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
      WAN_INTERNET="ONLINE"
    else
      echo -e "$Color_REDB$WAN Internet is offline on interface $WANIF$Color_BLACK"
      WAN_INTERNET="OFFLINE"
    fi

    if [ "$WAN" = "WAN1" ]
    then
      WAN1_INTERNET=$WAN_INTERNET
    fi

    if [ "$WAN" = "WAN2" ]
    then
      WAN2_INTERNET=$WAN_INTERNET
    fi

  fi
}
