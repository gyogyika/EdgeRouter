#!/bin/sh

SENDMAIL="/root/send-mail.sh"
PINGTOFILE="/root/pingto"

WANtest() {

WAN=$1
WANIF=$2
MESSAGE_LINE=""
COUNTPING=0
COUNTALL=0

while read -r PINGTO; do

  COUNTALL=$((COUNTALL+1))

  if ping -c1 -I "$WANIF" "$PINGTO" > /dev/null;
  then
    echo "$WAN ping OK. $PINGTO"
    # for testing only mail send
    # MESSAGE="$MESSAGE$PINGTO"'\n'

    COUNTPING=$((COUNTPING+1))
  else
    echo "$WAN ping problem. $PINGTO"
    MESSAGE_LINE="$MESSAGE_LINE$PINGTO, "
  fi

done < $PINGTOFILE

# for testing
# echo $COUNTPING
# echo $COUNTALL
NOPING=$((COUNTALL-COUNTPING))
echo "$WAN no ping: "$NOPING

if [ $NOPING -gt 10 ]
then
  $SENDMAIL "$WAN no ping to: $MESSAGE_LINE" "$MESSAGE_LINE"
fi

}

WANtest "WAN1" "eth0.5"
WANtest "WAN2" "eth0.1"
