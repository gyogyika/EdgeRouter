#!/bin/sh

SENDMAIL="/root/send-mail.sh"
read -r ROUTERNAME < "/root/routername"
read -r IPERF3 < "/root/iperf3"
read -r SPEEDTEST_URL < "/root/speedtest_url"
DOWNLOADSPEED=""
UPLOADSPEED=""
COUNTDOWNLOAD=0
COUNTUPLOAD=0

while [ -z "$DOWNLOADSPEED" ] && [ $COUNTDOWNLOAD -lt 5 ]
do
 COUNTDOWNLOAD=$((COUNTDOWNLOAD+1))
 echo Download test: $COUNTDOWNLOAD
 DOWNLOADSPEED=$(iperf3 -c $IPERF3 -f m -R | awk '/receiver/{print$7,$8}')
 echo Download speed: ="$DOWNLOADSPEED"=
 if [ -z "$DOWNLOADSPEED" ]
 then
  sleep 2
 fi
done

sleep 2

while [ -z "$UPLOADSPEED" ] && [ $COUNTUPLOAD -lt 5 ]
do
 COUNTUPLOAD=$((COUNTUPLOAD+1))
 echo Upload test: $COUNTUPLOAD
 UPLOADSPEED=$(iperf3 -c $IPERF3 -f m | awk '/receiver/{print$7,$8}')
 echo Upload speed: ="$UPLOADSPEED"=
 if [ -z "$UPLOADSPEED" ]
 then
  sleep 2
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
