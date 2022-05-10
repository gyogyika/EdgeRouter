#!/bin/bash

VPNRESULT="/tmp/VPNCLIENTS"

cat /dev/null > "$VPNRESULT"

for SERVERNAME in /var/run/openvpn.*.status;
  do
    #echo "$SERVERNAME"
    #awk -F: - field separator for : sign
    awk -F: '/^Common/{flag=1;next} /^ROUTING TABLE/{flag=0} flag {print $1}' "$SERVERNAME" >> "$VPNRESULT"
  done;

cat $VPNRESULT
