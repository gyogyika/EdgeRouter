#!/bin/sh

SENDMAIL="/root/send-mail.sh"
read -r ROUTERNAME < "/root/routername"
read -r IPERF3 < "/root/iperf3"
read -r IPERF3_PORT < "/root/iperf3_port"
read -r SPEEDTEST_URL < "/root/speedtest_url"
DOWNLOADSPEED=""
UPLOADSPEED=""
COUNTDOWNLOAD=0
COUNTUPLOAD=0

incport() {
  IPERF3_PORT=$((IPERF3_PORT+1))
  if [ $IPERF3_PORT -gt 9240 ] || [ $IPERF3_PORT -lt 9200 ]
  then
    IPERF3_PORT=9200
  fi
  echo $IPERF3_PORT > "/root/iperf3_port"
}


while [ -z "$DOWNLOADSPEED" ] && [ $COUNTDOWNLOAD -lt 5 ]
do
 COUNTDOWNLOAD=$((COUNTDOWNLOAD+1))
 echo Download test: $COUNTDOWNLOAD, Server: $IPERF3 $IPERF3_PORT
 DOWNLOADSPEED=$(iperf3 -c $IPERF3 $IPERF3_PORT -f m -R | awk '/receiver/{print$7,$8}')
 echo Download speed: ="$DOWNLOADSPEED"=
 if [ -z "$DOWNLOADSPEED" ]
 then
  sleep 2
  incport
 fi
done

sleep 2

while [ -z "$UPLOADSPEED" ] && [ $COUNTUPLOAD -lt 5 ]
do
 COUNTUPLOAD=$((COUNTUPLOAD+1))
 echo Upload test: $COUNTUPLOAD, Server: $IPERF3 $IPERF3_PORT
 UPLOADSPEED=$(iperf3 -c $IPERF3 $IPERF3_PORT -f m | awk '/receiver/{print$7,$8}')
 echo Upload speed: ="$UPLOADSPEED"=
 if [ -z "$UPLOADSPEED" ]
 then
  sleep 2
  incport
 fi
done

if [ $COUNTDOWNLOAD -gt 4 ]
then
  echo No download speedtest server "$IPERF3".
  #$SENDMAIL "No download speedtest server $IPERF3" "No speedtest server $IPERF3"
fi

if [ $COUNTUPLOAD -gt 4 ]
then
  echo No upload speedtest server "$IPERF3".
  #$SENDMAIL "No upload speedtest server $IPERF3" "No speedtest server $IPERF3"
fi

curl -G \
  --data-urlencode "name=$ROUTERNAME" \
  --data-urlencode "downloadspeed=$DOWNLOADSPEED" \
  --data-urlencode "uploadspeed=$UPLOADSPEED" \
$SPEEDTEST_URL
