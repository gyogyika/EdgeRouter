#!/bin/sh

#send-mail.sh "Send-arp.sh - test" "test"

FILE1="/root/Send-arp-current.log"
FILE2="/root/Send-arp-previous.log"
SENDMAIL="/root/send-mail.sh"

cat /proc/net/arp > $FILE1

diff $FILE1 $FILE2

#grep -E 'kern|auth|daemon.info|user' /tmp/system.log | tail -n20 > $FILE1

if [ $? -eq 0 ]
then
    printf 'The file "%s" is the same as "%s"\n' "$FILE1" "$FILE2"
else
    cp $FILE1 $FILE2
    echo "$FILE1"
    echo "changed to"
    echo "$FILE2"
    $SENDMAIL "arp change" "$(cat $FILE1) \nchanged to\n $(cat $FILE2)"
fi
