#!/bin/sh

SENDMAIL="/root/send-mail.sh"
LIST="/root/list-upgradable.txt"
TEMP="/tmp/list-upgradable.tmp"

opkg update
opkg list-upgradable > $TEMP

if [ -s $TEMP ]
then
    printf 'Update exist.\n'
    cp $TEMP $LIST
    cat $LIST
    opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade
    $SENDMAIL "Router updates installed" "$(cat $LIST)"
else
    printf 'No update.\n'
fi
