#!/bin/bash

source /root/settings.ini

#$SENDMAIL "Send-arp.sh - test" "test"

FILE1="/tmp/Send-arp-current.log"
FILE2="/root/log/Send-arp-previous.log"
RESULT="/tmp/arp-result"

cat /proc/net/arp > $FILE1

if [ ! -s $FILE2 ]
then
  #file has no data
  touch $FILE2
  echo File was created: "$FILE2"
fi

comm -3 --nocheck-order $FILE1 $FILE2 > $RESULT

if [ -s $RESULT ]
then
    #file has data
    cat $RESULT
    $SENDMAIL "arp changed" "$(cat $RESULT)"
    cp $FILE1 $FILE2
fi
