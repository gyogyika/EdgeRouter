#!/bin/bash

source /root/settings.ini
source /root/colors.ini

PINGTOSTK="/root/pingto2"
COUNTER=0

Pingto() {

 FILE=$1
 MESSAGE_LINE=""

 while read -r INTERFACEPINGTO; do

   DEVICE=$(echo "$INTERFACEPINGTO" | awk '{print $1}')
   INTERFACE=$(echo "$INTERFACEPINGTO" | awk '{print $2}')
   PINGTO=$(echo "$INTERFACEPINGTO" | awk '{print $3}')

   if ! [[ $DEVICE == "#"* || $INTERFACEPINGTO == "" ]];
   then

     COUNTER=$((COUNTER+1))

     if ping -c1 -W1 -I "$INTERFACE" "$PINGTO" > /dev/null;
     then
       echo -e "$COUNTER: $DEVICE $INTERFACE $PINGTO $Color_GREENB ping OK.$Color_BLACK"
     else
       echo -e "$COUNTER: $DEVICE $INTERFACE $PINGTO $Color_REDB ping NONE.$Color_BLACK"
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
