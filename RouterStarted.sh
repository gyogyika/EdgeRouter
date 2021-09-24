#!/bin/bash

ntpd -q -p 1.openwrt.pool.ntp.org

sleep 10

/root/send-mail.sh "Router started" "$(cat /tmp/system.log)"
