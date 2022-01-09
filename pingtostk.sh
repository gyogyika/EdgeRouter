#!/bin/bash

source /root/settings.ini

PINGTOSTK="/root/pingtostk"
COUNTER=0

Pingto() {

 FILE=$1
 MESSAGE_LINE=""

 while read -r INTERFACEPINGTO; do

   DEVICE=$(echo "$INTERFACEPINGTO" | awk '{print $1}')
   INTERFACE=$(echo "$INTERFACEPINGTO" | awk '{print $2}')
   PINGTO=$(echo "$INTERFACEPINGTO" | awk '{print $3}')

   if ! [[ $DEVICE == "#"* ]];
   then

     COUNTER=$((COUNTER+1))

     if ping -c1 -W1 -I "$INTERFACE" "$PINGTO" > /dev/null;
     then
       echo "$COUNTER: $DEVICE $INTERFACE $PINGTO ping OK."
     else
       echo "$COUNTER: $DEVICE $INTERFACE $PINGTO ping none."
       MESSAGE_LINE="$MESSAGE_LINE$DEVICE: $PINGTO"$'\n'
     fi
   fi

 done < "$FILE"

 if [[ -n "$MESSAGE_LINE" ]];
 then
   echo -e '\n'"No ping to:"'\n'"$MESSAGE_LINE"
   $SENDMAIL "ping none" "$MESSAGE_LINE"
 fi
}

echo -e '\n'
Pingto "$PINGTOSTK"

