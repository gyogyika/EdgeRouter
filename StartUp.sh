#!/bin/bash

bash "/root/copytotmp.sh"
sleep 10
source /tmp/root/settings.ini
bash "/root/settime.sh"
bash $SENDMAIL "Router started" "$(date)"
bash "/tmp/root/cron1minute.sh"
bash "/tmp/root/cron10minute.sh"
bash "/tmp/root/freemyip.sh"
