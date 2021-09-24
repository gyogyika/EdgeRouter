#!/bin/bash

if [ "$1" != "" ]
then
  VPNSTATUS=/var/run/openvpn.$1.status
  watch -n1 "echo $VPNSTATUS && cat $VPNSTATUS"
else
  echo "$1"

  COMMANDS=""

  ROWS=$(find /var/run/openvpn.*.status | wc -l)
  echo "Number of rows: $ROWS"

  I=0;

  for F in /var/run/openvpn.*.status;
  do
    #echo $F;
    COMMANDS="$COMMANDS echo $F && cat $F";
    I=$((I+1))
    if [ $I -lt "$ROWS" ]
    then
      COMMANDS="$COMMANDS && echo && ";
    fi
  done;

  #echo $COMMANDS
  watch -n1 "$COMMANDS"
fi
