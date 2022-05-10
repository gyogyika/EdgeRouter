#!/bin/bash

VPNCLIENTS="/tmp/VPNCLIENTS"

cat /dev/null > "$VPNCLIENTS"

for SERVERNAME in /var/run/openvpn.*.status;
  do
    #echo "$SERVERNAME"
    #awk -F: - field separator for : sign
    #awk -F: '/^Common/{flag=1;next} /^ROUTING TABLE/{flag=0} flag {print $1}' "$SERVERNAME" >> "$VPNCLIENTS"
    awk -F: '/^Virtual Address/{flag=1;next} /^GLOBAL STATS/{flag=0} flag {print $1}' "$SERVERNAME" >> "$VPNCLIENTS"
  done;

cat $VPNCLIENTS
