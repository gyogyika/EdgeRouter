#!/bin/bash

#running as server
iperf3 -s -f M

#client usage
#-R reverse mode, where the server sends and the client receives
#iperf3 -c 192.168.1.1 -f M -R
