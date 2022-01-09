#!/bin/bash

source /root/settings.ini

PINGTOSTK="/root/pingtostk"

Pingto() {

 FILE=$1
 MESSAGE_LINE=""

 while read -r INTERFACEPINGTO; do

   DEVICE=$(echo "$INTERFACEPINGTO" | awk '{print $1}')
   INTERFACE=$(echo "$INTERFACEPINGTO" | awk '{print $2}')
   PINGTO=$(echo "$INTERFACEPINGTO" | awk '{print $3}')

   #COUNTALL=$((COUNTALL+1))

   if ping -c1 -W1 -I "$INTERFACE" "$PINGTO" > /dev/null;
   then
     echo "$DEVICE $INTERFACE $PINGTO ping OK."
     # for testing only mail send
     # MESSAGE="$MESSAGE$PINGTO"'\n'

     #COUNTPING=$((COUNTPING+1))
   else
     echo "$DEVICE $INTERFACE $PINGTO ping none."
     MESSAGE_LINE="$MESSAGE_LINE$DEVICE: $PINGTO"$'\n'
   fi

 done < "$FILE"

 if [[ -n "$MESSAGE_LINE" ]];
 then
   echo -e "No ping to:"'\n'"$MESSAGE_LINE"
   $SENDMAIL "ping none" "$MESSAGE_LINE"
 fi
}

Pingto "$PINGTOSTK"

