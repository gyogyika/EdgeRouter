#!/bin/bash

source /tmp/root/settings.ini

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

if [ -n "$FREEMYIP3" ]
then
  echo "freemyip3:" "$FREEMYIP3"
  curl --max-time "$CURL_TIMEOUT" "$FREEMYIP3"
  echo
fi
