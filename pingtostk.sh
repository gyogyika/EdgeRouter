#!/bin/bash

source /root/settings.ini

PINGTOSTK="/root/pingtostk"
COUNTER=0

C_BLACK="\e[0m"
C_RED="\e[0;31m"
C_REDB="\e[1;31m"
C_GREEN="\e[0;32m"
C_GREENB="\e[1;32m"

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
       echo -e "$COUNTER: $DEVICE $INTERFACE $PINGTO $C_GREENB ping OK.$C_BLACK"
     else
       echo -e "$COUNTER: $DEVICE $INTERFACE $PINGTO $C_REDB ping NONE.$C_BLACK"
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

