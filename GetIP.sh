#!/bin/bash

source /root/settings.ini

echo
URL="$GETIP_URL"?name="$ROUTERNAME"
echo "GetIP:" "$URL"
curl --max-time "$CURL_TIMEOUT" "$URL"
echo
echo

if [ -n "$FREEMYIP" ]
then
  echo "freemyip:" "$FREEMYIP"
  curl --max-time "$CURL_TIMEOUT" "$FREEMYIP"
  echo
fi

if [ -n "$FREEMYIP2" ]
then
  echo "freemyip2:" "$FREEMYIP2"
  curl --max-time "$CURL_TIMEOUT" "$FREEMYIP2"
  echo
fi
