#!/bin/bash

source /root/settings.ini

#$SENDMAIL "Send-log.sh - test" "test"

FILE1="/tmp/Send-log-current.log"
FILE2="/tmp/Send-log-previous.log"

grep -E 'kern|auth|daemon.info|user' /tmp/system.log | tail -n20 > $FILE1

if cmp -s "$FILE1" "$FILE2"
then
    printf 'The file "%s" is the same as "%s"\n' "$FILE1" "$FILE2"
else
    cp $FILE1 $FILE2
    LASTROW="$(tail -n1 $FILE1)"
    echo "$LASTROW"
    $SENDMAIL "logread - $LASTROW" "$(cat $FILE1)"
fi
