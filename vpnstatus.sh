#!/bin/sh

echo "$1"

if [ -z "$1" ]
then
  watch -n1 "echo pomocVPN && cat /var/run/openvpn.pomocvpn.status && echo && echo pomocVPN_Linux && cat /var/run/openvpn.pomocvpn_linux.status && echo && echo SERVER && cat /var/run/openvpn.server.status && echo && echo pederVPN && cat /var/run/openvpn.pedervpn.status"
fi

