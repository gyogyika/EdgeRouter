#!/bin/bash

read -r IPERF3_PORT < "/root/iperf3_port"

IPERF3_PORT=$((IPERF3_PORT+1))

echo $IPERF3_PORT > "/root/iperf3_port"
