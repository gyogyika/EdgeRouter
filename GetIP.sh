#!/bin/sh
read -r ROUTERNAME < "/root/routername"
read -r GETIP_URL < "/root/GetIP_url"

curl "$GETIP_URL""$ROUTERNAME"

read -r FREEMYIP < "/root/freemyip"
curl "$FREEMYIP"

read -r FREEMYIP2 < "/root/freemyip2"
curl "$FREEMYIP2"
