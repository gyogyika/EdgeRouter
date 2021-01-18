#!/bin/sh

SENDMAIL="/root/send-mail.sh"
read -r ROUTERNAME < "/root/routername"
read -r IPERF3 < "/root/iperf3"
read -r SPEEDTEST_URL < "/root/speedtest_url"
DOWNLOADSPEED=""
UPLOADSPEED=""
COUNT=0

while [ -z "$DOWNLOADSPEED" ] && [ $COUNT -lt 5 ]
do
 COUNT=$((COUNT+1))
 echo Download test: $COUNT
 DOWNLOADSPEED=$(iperf3 -c $IPERF3 -f m -R | awk '/receiver/{print$7,$8}')
 echo Download speed: ="$DOWNLOADSPEED"=
 if [ -z "$DOWNLOADSPEED" ]
 then
  sleep 2
 else
  echo Upload test: $COUNT
  UPLOADSPEED=$(iperf3 -c $IPERF3 -f m | awk '/receiver/{print$7,$8}')
  echo Upload speed: ="$UPLOADSPEED"=
 fi
done

if [ $COUNT -gt 4 ]
then
  echo No speedtest server "$IPERF3".
  #$SENDMAIL "No speedtest server $IPERF3" "No speedtest server $IPERF3"
fi

curl -G \
  --data-urlencode "name=$ROUTERNAME" \
  --data-urlencode "downloadspeed=$DOWNLOADSPEED" \
  --data-urlencode "uploadspeed=$UPLOADSPEED" \
$SPEEDTEST_URL
