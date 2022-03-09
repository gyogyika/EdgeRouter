#!/bin/bash

source /root/settings.ini

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

curl -G \
  --data-urlencode "from=$SENDMAIL_FROM" \
  --data-urlencode "subject=$SUBJECT" \
  --data-urlencode "message=$MESSAGE" \
  "$SENDMAIL_URL"

#mailsend -f "$SENDMAIL_FROM" -t "$SENDMAIL_TO" -sub "$SUBJECT" -M "$MESSAGE" -smtp localhost

NOW=$(date +"%d.%m.%Y %A, %H:%M")
echo "$NOW - $1" >> /tmp/send-mail.log
