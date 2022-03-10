#!/bin/bash

source /root/settings.ini
source /root/send-mail-save.sh

if [ -z "$1" ]
then
 SUBJECT="EMPTY"
else
 SUBJECT=$1
fi

if [ -z "$2" ]
then
 MESSAGE="EMPTY"
else
 MESSAGE=$2
fi

STATUS=$(curl --max-time 1 --silent --get --data-urlencode "test=test" "$SENDMAIL_URL")

if [ "$STATUS" = "OK" ]
then
 #echo status OK
 curl --max-time 5 --silent --get \
  --data-urlencode "from=$SENDMAIL_FROM" \
  --data-urlencode "subject=$SUBJECT" \
  --data-urlencode "message=$MESSAGE" \
  "$SENDMAIL_URL"
else
  echo Not connected
  SaveMail
fi

#mailsend -f "$SENDMAIL_FROM" -t "$SENDMAIL_TO" -sub "$SUBJECT" -M "$MESSAGE" -smtp localhost

NOW=$(date +"%d.%m.%Y %A, %H:%M")
echo "$NOW - $1" >> /tmp/send-mail.log
