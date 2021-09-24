#!/bin/bash

source /root/settings.ini

echo
echo "GetIP:" "$GETIP_URL""$ROUTERNAME"
curl "$GETIP_URL""$ROUTERNAME"
echo
echo

echo "freemyip:" "$FREEMYIP"
curl "$FREEMYIP"
echo

echo "freemyip2:" "$FREEMYIP2"
curl "$FREEMYIP2"
echo
