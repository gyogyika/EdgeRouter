#!/bin/sh

read -r ROUTERNAME < "/root/routername"
read -r SENDMAIL_FROM < "/root/send-mail_from"
read -r SENDMAIL_TO < "/root/send-mail_to"

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

mailsend -f "$ROUTERNAME"@"$SENDMAIL_FROM" -t "$SENDMAIL_TO" -sub "$SUBJECT" -M "$MESSAGE" -smtp localhost
NOW=$(date +"%d.%m.%Y %A, %H:%M")
echo "$NOW - $1" >> /root/send-mail.log
