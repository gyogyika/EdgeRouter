#!/bin/bash

source /root/settings.ini

echo
URL="$GETIP_URL"?name="$ROUTERNAME"
echo "GetIP:" "$URL"
curl --max-time 5 "$URL"
echo
echo

echo "freemyip:" "$FREEMYIP"
curl --max-time 5 "$FREEMYIP"
echo

echo "freemyip2:" "$FREEMYIP2"
curl --max-time 5 "$FREEMYIP2"
echo
