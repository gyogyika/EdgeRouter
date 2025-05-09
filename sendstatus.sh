#!/bin/bash

source /tmp/root/settings.ini
source /tmp/root/utils

get_wan_status "WAN1"
WAN1_STATUS=$WAN_STATUS
echo WAN1: $WAN1_STATUS

echo WAN1 ISP: $WAN1ISPNAME

get_wan_status "WAN2"
WAN2_STATUS=$WAN_STATUS
echo WAN2: $WAN2_STATUS

echo WAN2 ISP: $WAN2ISPNAME

get_wan_status "WAN3"
WAN3_STATUS=$WAN_STATUS
echo WAN3: $WAN3_STATUS

echo WAN3 ISP: $WAN3ISPNAME

# : ending char for interface name, e.g.: br-lan:
# For LAN side download
LAN_TX=$(cat /proc/net/dev | awk '/'"$LANIF"':/ {print $2}')
echo $LANIF "LAN_TX:" $LAN_TX

# For LAN side upload
LAN_RX=$(cat /proc/net/dev | awk '/'"$LANIF"':/ {print $10}')
echo $LANIF "LAN_RX:" $LAN_RX

# For WAN side download
WAN_RX=$(cat /proc/net/dev | awk '/'"$WAN1IF"':/ {print $2}')
echo $WAN1IF "WAN_RX:" $WAN_RX

# For WAN side upload
WAN_TX=$(cat /proc/net/dev | awk '/'"$WAN1IF"':/ {print $10}')
echo $WAN1IF "WAN_TX:" $WAN_TX

MACHINE=$(cat /proc/cpuinfo | awk -F': ' '/machine/ {print $2}')
echo MACHINE: $MACHINE

SYSTEM_TYPE=$(cat /proc/cpuinfo | awk -F': ' '/system type/ {print $2}')
echo SYSTEM_TYPE: $SYSTEM_TYPE

CPU_CORES=$(cat /proc/cpuinfo | awk -F: '/processor/ {print $0}' | wc -l)
echo CPU_CORES: $CPU_CORES

MONITORINGVER="invalid"
read -r MONITORINGVER < "/tmp/root/monitoringver"
echo MONITORINGVER: $MONITORINGVER

NOPINGS="invalid"
read -r NOPINGS < "/tmp/NOPINGS"
echo NOPINGS: $NOPINGS

NOPINGS_CRIT="invalid"
read -r NOPINGS_CRIT < "/tmp/NOPINGS_CRIT"
echo NOPINGS_CRIT: $NOPINGS_CRIT

PINGS="invalid"
read -r PINGS < "/tmp/PINGS"
echo PINGS: $PINGS

SPEEDTEST="invalid"
read -r SPEEDTEST < "/tmp/SPEEDTEST"
echo SPEEDTEST: $SPEEDTEST

PING=$(ping -c1 www.msftncsi.com | awk -F/ '{print $5}')
echo PING: $PING

VPNCLIENTS="invalid"
VPNCLIENTS=$(awk '{print}' "/tmp/VPNCLIENTS") #multiline read
echo VPNCLIENTS: $VPNCLIENTS

DHCP_LEASES=$(awk 'END{print NR}' "/tmp/dhcp.leases")
echo DHCP Leases: $DHCP_LEASES

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

if [ -n "$VPNCERT" ]
then
  CERT_EXP=$(openssl x509 -enddate -noout -in "$VPNCERT" | awk -F'=' '{print $2}')
  echo "VPN cert expiration Not After: ""$CERT_EXP"

  CERT_EXP_DAY=$(echo "$CERT_EXP" | awk '{print $2}')
  #echo "$CERT_EXP_DAY"

  CERT_EXP_MONTH_NAME=$(echo "$CERT_EXP" | awk '{print $1}')
  #echo "$CERT_EXP_MONTH_NAME"

  CERT_EXP_MONTH=$(echo "$CERT_EXP_MONTH_NAME" | awk '{printf "%01d",(index("JanFebMarAprMayJunJulAugSepOctNovDec",$0)+2)/3}')
  #echo "$CERT_EXP_MONTH"

  CERT_EXP_YEAR=$(echo "$CERT_EXP" | awk '{print $4}')
  #echo "$CERT_EXP_YEAR"

  VPNCERTEXP=$CERT_EXP_DAY.$CERT_EXP_MONTH.$CERT_EXP_YEAR
  echo "VPN cert expiration: ""$VPNCERTEXP"
fi

if [ -n "$VPNCERT2" ]
then
  CERT_EXP=$(openssl x509 -enddate -noout -in "$VPNCERT2" | awk -F'=' '{print $2}')
  echo "VPN cert expiration Not After: ""$CERT_EXP"

  CERT_EXP_DAY=$(echo "$CERT_EXP" | awk '{print $2}')
  #echo "$CERT_EXP_DAY"

  CERT_EXP_MONTH_NAME=$(echo "$CERT_EXP" | awk '{print $1}')
  #echo "$CERT_EXP_MONTH_NAME"

  CERT_EXP_MONTH=$(echo "$CERT_EXP_MONTH_NAME" | awk '{printf "%01d",(index("JanFebMarAprMayJunJulAugSepOctNovDec",$0)+2)/3}')
  #echo "$CERT_EXP_MONTH"

  CERT_EXP_YEAR=$(echo "$CERT_EXP" | awk '{print $4}')
  #echo "$CERT_EXP_YEAR"

  VPNCERT2EXP=$CERT_EXP_DAY.$CERT_EXP_MONTH.$CERT_EXP_YEAR
  echo "VPN cert 2 expiration: ""$VPNCERT2EXP"
fi

TIME=$(date +%s)

if [ "$UPS_ENABLED" = "1" ]
then
  echo "UPS_ENABLED: $UPS_ENABLED"
  UPS=$(upsc ups)

  UPS_model=$(echo "$UPS" | awk '/ups.model:/{$1="";print $0}')
  echo "UPS_model: $UPS_model"

  if [ -z "$UPS_battery_date" ]
  then
    UPS_battery_date=$(echo "$UPS" | awk '/battery.mfr.date:/{$1="";print $0}')
  fi
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
fi

curl --get \
  --data-urlencode "set=router" \
  --data-urlencode "name=$ROUTERNAME" \
  --data-urlencode "WAN1=$WAN1_STATUS" \
  --data-urlencode "WAN2=$WAN2_STATUS" \
  --data-urlencode "WAN3=$WAN3_STATUS" \
  --data-urlencode "WAN1_ISP=$WAN1ISPNAME" \
  --data-urlencode "WAN2_ISP=$WAN2ISPNAME" \
  --data-urlencode "WAN3_ISP=$WAN3ISPNAME" \
  --data-urlencode "LAN_RX=$LAN_RX" \
  --data-urlencode "LAN_TX=$LAN_TX" \
  --data-urlencode "WAN_RX=$WAN_RX" \
  --data-urlencode "WAN_TX=$WAN_TX" \
  --data-urlencode "MACHINE=$MACHINE" \
  --data-urlencode "SYSTEM_TYPE=$SYSTEM_TYPE" \
  --data-urlencode "CPU_CORES=$CPU_CORES" \
  --data-urlencode "PINGS=$PINGS" \
  --data-urlencode "NOPINGS=$NOPINGS" \
  --data-urlencode "NOPINGS_CRIT=$NOPINGS_CRIT" \
  --data-urlencode "Memory_load=$Memory_load" \
  --data-urlencode "time=$TIME" \
  --data-urlencode "MONITORINGVER=$MONITORINGVER" \
  --data-urlencode "SPEEDTEST=$SPEEDTEST" \
  --data-urlencode "PING=$PING" \
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
  --data-urlencode "VPNCERTEXP=$VPNCERTEXP" \
  --data-urlencode "VPNCERT2EXP=$VPNCERT2EXP" \
"$STATUS_URL"
