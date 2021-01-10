#!/bin/sh
iperf3 -c localhost -f m -R | awk '/receiver/{print$7,$8}'
