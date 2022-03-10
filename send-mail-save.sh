#!/bin/bash

SAVE_DIR="/tmp/spool/sendmail/"
SMCF="/tmp/savemail_counter"

get_counter() {
  read -r SAVEMAIL_COUNTER < "$SMCF"
  if [ "$SAVEMAIL_COUNTER" = "" ]
  then
    SAVEMAIL_COUNTER=0
  fi
}

inc_counter() {
  get_counter
  SAVEMAIL_COUNTER=$((SAVEMAIL_COUNTER+1))
  echo "$SAVEMAIL_COUNTER" > "$SMCF"
}

SaveMail() {
  SUBJECT=$1
  MESSAGE=$2
  SAVEMAIL_COUNTER=""
  [ ! -d "$SAVE_DIR" ] && mkdir -p "$SAVE_DIR"
  inc_counter
  FILE="$SAVE_DIR""$SAVEMAIL_COUNTER"
  echo "Subject: ""$SUBJECT" > "$FILE"
  echo "$MESSAGE" >> "$FILE"
  echo "${FUNCNAME[0]}(): Mail saved locally to ""$FILE"
}

get_server_status() {
  STATUS=$(curl --max-time 2 --silent --get --data-urlencode "test=test" "$SENDMAIL_URL")
}

SendMail() {
  SUBJECT=$1
  MESSAGE=$2

  get_server_status

  if [ "$STATUS" = "OK" ]
  then
    printf "%s" "${FUNCNAME[0]}(): "
    curl --max-time 5 --silent --get \
      --data-urlencode "from=$SENDMAIL_FROM" \
      --data-urlencode "subject=$SUBJECT" \
      --data-urlencode "message=$MESSAGE" \
      "$SENDMAIL_URL"
  else
    echo "${FUNCNAME[0]}(): No connection to ""$SENDMAIL_URL"
    SaveMail "$SUBJECT" "$MESSAGE"
  fi
}

SendSavedMails() {

  if [ "$(ls -A "$SAVE_DIR")" ]

  then

    get_server_status

    if [ "$STATUS" = "OK" ]
    then
      for FILE in "$SAVE_DIR"*
      do
        echo "$FILE"
        read -r SUBJECT < "$FILE"
        MESSAGE=$(<"$FILE")
        SendMail "$SUBJECT" "$MESSAGE"
        rm "$FILE"
      done
    else
      echo "${FUNCNAME[0]}(): No connection to ""$SENDMAIL_URL"
    fi

  else
    echo "${FUNCNAME[0]}(): No mail files to send."
  fi
}

