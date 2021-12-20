#!/bin/bash

source /root/settings.ini

#$SENDMAIL "Send-arp.sh - test" "test"

FILE1="/tmp/Send-arp-current.log"
FILE2="/root/log/Send-arp-previous.log"
RESULT="/tmp/arp-result"

cat /proc/net/arp > $FILE1

if [ ! -s $FILE2 ]
then
    #file FILE2 has no data
    if touch $FILE2
    then
       echo File was created: "$FILE2"
    else
       echo File was not created: "$FILE2"
       $SENDMAIL "Send-arp.sh" "File was not created: $FILE2"
    fi
fi

comm -3 --nocheck-order $FILE1 $FILE2 > $RESULT

if [ -s $RESULT ]
then
    #file RESULT has data
    cat $RESULT
    $SENDMAIL "arp changed" "$(cat $RESULT)"
    cp $FILE1 $FILE2
else
    echo No new entries.
fi
