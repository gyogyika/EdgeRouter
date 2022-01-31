#!/bin/bash

source /root/settings.ini

WANtest() {

WAN=$1
WANIF=$2
MESSAGE_LINE=""
COUNTPING=0
COUNTALL=0

while read -r PINGTO; do

  PING=$(echo "$PINGTO" | awk '{print $1}')

  if ! [[ $PING == "#"* || $PINGTO == "" ]];
  then

    COUNTALL=$((COUNTALL+1))

    if ping -c1 -W1 -I "$WANIF" "$PING" > /dev/null;
    then
      echo "$WAN ping OK. $PING"
      # for testing only mail send
      # MESSAGE="$MESSAGE$PING"'\n'

      COUNTPING=$((COUNTPING+1))
    else
      echo "$WAN ping problem. $PING"
      MESSAGE_LINE="$MESSAGE_LINE$PINGTO, "
    fi
  fi

done < "$PINGTOFILE"

# for testing
# echo $COUNTPING
# echo $COUNTALL
NOPING=$((COUNTALL-COUNTPING))
echo "$WAN no ping: "$NOPING

if [ $NOPING -gt 0 ]
then
  $SENDMAIL "$WAN no ping to: $MESSAGE_LINE" "$MESSAGE_LINE"
fi

}

WANtest "WAN1" "$WAN1"
WANtest "WAN2" "$WAN2"
