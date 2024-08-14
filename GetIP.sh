#!/bin/bash

source /tmp/root/settings.ini

echo
URL="$GETIP_URL"?name="$ROUTERNAME"
echo "GetIP:" "$URL"
curl --max-time "$CURL_TIMEOUT" "$URL"
echo
