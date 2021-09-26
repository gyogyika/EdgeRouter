#!/bin/bash

source /root/settings.ini

#$SENDMAIL "Send-dhcp.sh - test" "test"

FILE1="/tmp/dhcp-current.log"
FILE2="/tmp/dhcp-previous.log"

awk '/no address available$/ {print $9, $10, $11, $12}' /tmp/system.log | sort -u > $FILE1

if cmp -s "$FILE1" "$FILE2"
then
    printf 'The file "%s" is the same as "%s"\n' "$FILE1" "$FILE2"
else
    cp $FILE1 $FILE2
    echo "$FILE1"
    echo "changed to"
    echo "$FILE2"
    if [ -s $FILE1 ]
    then
      $SENDMAIL "DHCPDISCOVER" "$(cat $FILE1)"
    fi
fi
