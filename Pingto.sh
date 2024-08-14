#!/bin/bash

source /tmp/root/settings.ini
source /tmp/root/colors.ini

COUNTER=0
PING_COUNTER=0
NO_PING_COUNTER=0
NO_PING_CRIT_COUNTER=0
PING_DEVICE=""
NO_PING_DEVICE=""
NO_PING_CRIT_DEVICE=""
PINGS="/tmp/PINGS"
NOPINGS="/tmp/NOPINGS"
NOPINGS_CRIT="/tmp/NOPINGS_CRIT"
echo "" > $NOPINGS
echo "" > $NOPINGS_CRIT
echo "" > $PINGS

Pingto() {

 FILE=$1
 MESSAGE_LINE_PINGS_CRIT=""

 while read -r INTERFACEPINGTO; do

   DEVICE=$(echo "$INTERFACEPINGTO" | awk '{print $1}')
   INTERFACE=$(echo "$INTERFACEPINGTO" | awk '{print $2}')
   PINGTO=$(echo "$INTERFACEPINGTO" | awk '{print $3}')
   CRITICAL=$(echo "$INTERFACEPINGTO" | awk '{print $4}')

   if ! [[ $DEVICE == "#"* || $INTERFACEPINGTO == "" ]];
   then

     COUNTER=$((COUNTER+1))

     if ping -c1 -W1 -I "$INTERFACE" "$PINGTO" > /dev/null;
     then
       echo -e "$COUNTER: $DEVICE $INTERFACE $PINGTO $Color_GREENB ping OK.$Color_BLACK"
       PING_COUNTER=$((PING_COUNTER+1))
       PING_DEVICE=$PING_DEVICE$DEVICE" | "
     else
       echo -e "$COUNTER: $DEVICE $INTERFACE $PINGTO $Color_REDB ping NONE. $CRITICAL$Color_BLACK"
       if [[ $CRITICAL == "critical" ]]
       then
         MESSAGE_LINE_PINGS_CRIT="$MESSAGE_LINE_PINGS_CRIT$DEVICE: $PINGTO"$'\n'
         NO_PING_CRIT_COUNTER=$((NO_PING_CRIT_COUNTER+1))
         NO_PING_CRIT_DEVICE=$NO_PING_CRIT_DEVICE$DEVICE" | "
       fi
       NO_PING_COUNTER=$((NO_PING_COUNTER+1))
       NO_PING_DEVICE=$NO_PING_DEVICE$DEVICE" | "
     fi
   fi

 done < "$FILE"

 if [[ -n "$MESSAGE_LINE_PINGS_CRIT" ]];
 then
   echo -e '\n'"No ping to critical devices:"'\n'"$MESSAGE_LINE"
   $SENDMAIL "ping none critical $NO_PING_CRIT_COUNTER: $NO_PING_CRIT_DEVICE"  "$MESSAGE_LINE_PINGS_CRIT"
 fi

 if [ $NO_PING_COUNTER -gt 0 ]
 then
   echo -e $NO_PING_DEVICE > $NOPINGS
 fi

 if [ $NO_PING_CRIT_COUNTER -gt 0 ]
 then
   echo -e $NO_PING_CRIT_DEVICE > $NOPINGS_CRIT
 fi

 if [ $PING_COUNTER -gt 0 ]
 then
   echo -e $PING_DEVICE > $PINGS
 fi

}
