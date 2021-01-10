#!/bin/sh

VPNuserloggedin() {
  RET=$(awk '/pomocvpnclient/ {print}' /var/run/openvpn.pomocvpn.status)
  echo =$RET=
  if [ -z "$RET" ]
  then
    #not loggen in
    # 1 = false
    return 1
  else
    #loggen in
    # 0 = true
    return 0
  fi
}

if VPNuserloggedin;
then
  echo Logged in.
else
  echo Not logged in.
fi

