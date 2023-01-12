#!/bin/bash

source /root/settings.ini

sleep "$SLEEP"

read -r IPERF3_PORT < "$IPERF3_PORT_FILE"

DOWNLOADSPEED=""
UPLOADSPEED=""
COUNTDOWNLOAD=0
COUNTUPLOAD=0

if [ -z "$IPERF3_START_PORT" ]
then
  IPERF3_START_PORT="5200"
fi

if [ -z "$IPERF3_END_PORT" ]
then
  IPERF3_END_PORT="5209"
fi

if [ -z "$IPERF3_PORT" ]
then
  IPERF3_PORT=$IPERF3_START_PORT
fi

echo "Iperf3 port: ""$IPERF3_PORT"

incport() {
  IPERF3_PORT=$((IPERF3_PORT+1))
  if [ $IPERF3_PORT -gt "$IPERF3_END_PORT" ] || [ $IPERF3_PORT -lt "$IPERF3_START_PORT" ]
  then
    IPERF3_PORT=$IPERF3_START_PORT
  fi
  echo "$IPERF3_PORT" > "$IPERF3_PORT_FILE"
}

while [ -z "$DOWNLOADSPEED" ] && [ $COUNTDOWNLOAD -lt 15 ]
do
 COUNTDOWNLOAD=$((COUNTDOWNLOAD+1))
 echo Download test: $COUNTDOWNLOAD, Server: "$IPERF3_SERVER" "$IPERF3_PORT"
 DOWNLOADSPEED=$(iperf3 -c "$IPERF3_SERVER" -p "$IPERF3_PORT" -f m -R | awk '/receiver/{print$7,$8}')
 echo Download speed: ="$DOWNLOADSPEED"=
 if [ -z "$DOWNLOADSPEED" ]
 then
  sleep 5
  incport
 fi
done

sleep 2

while [ -z "$UPLOADSPEED" ] && [ $COUNTUPLOAD -lt 15 ]
do
 COUNTUPLOAD=$((COUNTUPLOAD+1))
 echo Upload test: $COUNTUPLOAD, Server: "$IPERF3_SERVER" "$IPERF3_PORT"
 UPLOADSPEED=$(iperf3 -c "$IPERF3_SERVER" -p "$IPERF3_PORT" -f m | awk '/receiver/{print$7,$8}')
 echo Upload speed: ="$UPLOADSPEED"=
 if [ -z "$UPLOADSPEED" ]
 then
  sleep 5
  incport
 fi
done

if [ $COUNTDOWNLOAD -gt 14 ]
then
  echo No download speedtest server "$IPERF3_SERVER".
  #$SENDMAIL "No download speedtest server $IPERF3_SERVER" "No speedtest server $IPERF3_SERVER"
fi

if [ $COUNTUPLOAD -gt 14 ]
then
  echo No upload speedtest server "$IPERF3_SERVER".
  #$SENDMAIL "No upload speedtest server $IPERF3_SERVER" "No speedtest server $IPERF3_SERVER"
fi

curl --max-time 5 --get \
  --data-urlencode "name=$ROUTERNAME" \
  --data-urlencode "downloadspeed=$DOWNLOADSPEED" \
  --data-urlencode "uploadspeed=$UPLOADSPEED" \
"$SPEEDTEST_URL"

echo "$DOWNLOADSPEED / $UPLOADSPEED" > /tmp/SPEEDTEST
