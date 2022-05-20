#!/bin/bash

source /root/settings.ini
source /root/utils

get_wan_status "WAN1"
WAN1_STATUS=$WAN_STATUS

get_wan_status "WAN2"
WAN2_STATUS=$WAN_STATUS

NOPINGS="invalid"
read -r NOPINGS < "/tmp/NOPINGS"

SPEEDTEST="invalid"
read -r SPEEDTEST < "/tmp/SPEEDTEST"

VPNCLIENTS="invalid"
VPNCLIENTS=$(awk '{print}' "/tmp/VPNCLIENTS") #multiline read

DHCP_LEASES=$(awk 'END{print NR}' "/tmp/dhcp.leases")
#echo DHCP Leases: $DHCP_LEASES

ARP_count=$(cat /proc/net/arp | wc -l)
((ARP_count=ARP_count-1))
echo "ARP_count: $ARP_count"

Memory_load=$(free -t | awk 'NR==2 {print $3/$2*100}')
echo "Memory_load: $Memory_load"

Uptime=$(cat /proc/stat | awk '/^btime/{print $2}')
echo "Uptime: $Uptime"

CPU_load=$(top -n1 | awk '/^CPU/{print $2$3" "$4$5" "$6$7" "$8$9" "$10$11" "$12$13" "$14$15}')
echo "CPU_load: $CPU_load"

TIME=$(date +%s)

curl --get \
  --data-urlencode "set=router" \
  --data-urlencode "name=$ROUTERNAME" \
  --data-urlencode "WAN1=$WAN1_STATUS" \
  --data-urlencode "WAN2=$WAN2_STATUS" \
  --data-urlencode "NOPINGS=$NOPINGS" \
  --data-urlencode "Memory_load=$Memory_load" \
  --data-urlencode "time=$TIME" \
  --data-urlencode "SPEEDTEST=$SPEEDTEST" \
  --data-urlencode "VPNCLIENTS=$VPNCLIENTS" \
  --data-urlencode "DHCP_LEASES=$DHCP_LEASES" \
  --data-urlencode "Uptime=$Uptime" \
  --data-urlencode "ARP_count=$ARP_count" \
  --data-urlencode "CPU_load=$CPU_load" \
"$STATUS_URL"
