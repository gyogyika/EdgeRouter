#!/bin/bash

source /root/settings.ini

#1st line is the username
USERNAME=$(awk 'NR==1' "$1")

#2nd line is the password
PASSWORD=$(awk 'NR==2' "$1")

HASH=$(printf "%s" "$PASSWORD" | md5sum)
HASH=$(echo "$HASH" | cut -c 1-32)

while read -r line; do

  USERNAME_FILE=$(echo "$line" | cut -d ':' -f1)
  HASH_FILE=$(echo "$line" | cut -d ':' -f2)

  if [ "$USERNAME" = "$USERNAME_FILE" ] && [ "$HASH" = "$HASH_FILE" ]
  then
    echo "ok"
    $SENDMAIL "OpenVPN auth success: $USERNAME" "OpenVPN auth success."
    exit 0
  fi

done < "authusers"

echo "not ok"
$SENDMAIL "OpenVPN auth failed: $USERNAME" "OpenVPN auth failed. Username: $USERNAME, password: $PASSWORD"
exit 1
