#!/bin/bash

source /root/settings.ini

echo
URL="$GETIP_URL"?name="$ROUTERNAME"
echo "GetIP:" "$URL"
curl "$URL"
echo
echo

echo "freemyip:" "$FREEMYIP"
curl "$FREEMYIP"
echo

echo "freemyip2:" "$FREEMYIP2"
curl "$FREEMYIP2"
echo
