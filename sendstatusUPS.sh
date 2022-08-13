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

CPU=$(top -n1 | awk '/^CPU/{$1="";print $0}')
echo "CPU: $CPU"

CPU_load=$(echo "$CPU" | awk '{print $7}')
#echo "CPU_load: $CPU_load"

# remove % sign
CPU_load=$(echo "$CPU_load" | awk -F% '{print $1}')

CPU_load=$((100-$CPU_load))
echo "CPU_load: $CPU_load"

Storage_load=$(df -h | awk '/overlayfs/ {print $5}')
echo "Storage_load: $Storage_load"

OpenWrt=$(awk -F= '/DISTRIB_DESCRIPTION/ {print $2}' /etc/openwrt_release)
echo "OpenWrt: $OpenWrt"

TIME=$(date +%s)

UPS=$(upsc ups)

UPS_model=$(echo "$UPS" | awk '/ups.model:/{$1="";print $0}')
echo "UPS_model: $UPS_model"

UPS_battery_date=$(echo "$UPS" | awk '/battery.mfr.date:/{$1="";print $0}')
echo "UPS_battery_date: $UPS_battery_date"

UPS_battery_charge=$(echo "$UPS" | awk '/battery.charge:/{$1="";print $0}')
echo "UPS_battery_charge: $UPS_battery_charge"

UPS_battery_time=$(echo "$UPS" | awk '/battery.runtime:/{$1="";print $0}')
echo "UPS_battery_time: $UPS_battery_time"

UPS_battery_voltage=$(echo "$UPS" | awk '/battery.voltage:/{$1="";print $0}')
echo "UPS_battery_voltage: $UPS_battery_voltage"

UPS_load=$(echo "$UPS" | awk '/ups.load:/{$1="";print $0}')
echo "UPS_load: $UPS_load"

UPS_voltage=$(echo "$UPS" | awk '/input.voltage:/{$1="";print $0}')
echo "UPS_voltage: $UPS_voltage"

UPS_status=$(echo "$UPS" | awk '/ups.status:/{$1="";print $0}')
echo "UPS_status: $UPS_status"

UPS_date=$(echo "$UPS" | awk '/ups.mfr.date:/{$1="";print $0}')
echo "UPS_date: $UPS_date"

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
  --data-urlencode "CPU=$CPU" \
  --data-urlencode "CPU_load=$CPU_load" \
  --data-urlencode "Storage_load=$Storage_load" \
  --data-urlencode "OpenWrt=$OpenWrt" \
  --data-urlencode "UPS_model=$UPS_model" \
  --data-urlencode "UPS_battery_date=$UPS_battery_date" \
  --data-urlencode "UPS_battery_charge=$UPS_battery_charge" \
  --data-urlencode "UPS_battery_time=$UPS_battery_time" \
  --data-urlencode "UPS_battery_voltage=$UPS_battery_voltage" \
  --data-urlencode "UPS_load=$UPS_load" \
  --data-urlencode "UPS_voltage=$UPS_voltage" \
  --data-urlencode "UPS_status=$UPS_status" \
  --data-urlencode "UPS_date=$UPS_date" \
"$STATUS_URL"
