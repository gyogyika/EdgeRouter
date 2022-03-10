#!/bin/bash

source /root/settings.ini

#emailrelay --as-server --forward-on-disconnect --poll=60 --forward-to="$SMTP_SERVER":465 --client-tls-connection --client-auth=/etc/emailrelay.auth --log-file=/tmp/emailrelay.log --no-syslog

sleep 10

ntpd -q -p 1.openwrt.pool.ntp.org

$SENDMAIL "Router started" "$(date)"

$GETIP
