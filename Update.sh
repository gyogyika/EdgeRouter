#!/bin/bash

source /root/settings.ini

LIST="/tmp/list-upgradable.log"

opkg update
opkg list-upgradable > $LIST

if [ -s $LIST ]
then
    printf 'Update exist.\n'
    cat $LIST
    opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade
    $SENDMAIL "Router updates installed" "$(cat $LIST)"
else
    printf 'No update.\n'
fi
