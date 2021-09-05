#!/bin/sh

if [ -z "$1" ]
then
echo "$1"

C=""

ROWS=$(ls /var/run/openvpn.*.status | wc -l)
echo "Number of rows: " $ROWS

I=0;

for F in /var/run/openvpn.*.status;
  do
    #echo $F;
    C="$C echo $F && cat $F";
    I=$((I+1))
    if [ $I -lt $ROWS ]
    then
      C="$C && echo && ";
    fi
done;

#echo $C
watch -n1 $C
fi

if [ "$1" != "" ]
then
  VPNSTATUS=/var/run/openvpn.$1.status
  watch -n1 "echo $VPNSTATUS && cat $VPNSTATUS"
fi
