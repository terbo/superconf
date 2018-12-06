#!/bin/sh

ACT=$1
MAC=$2
IP=$3
HOST=$4

IFACE=$DNSMASQ_INTERFACE
CID=$DNSMASQ_CLIENT_ID

LOG="$(date)  ($ACT) $HOST ($IP - $MAC / $CID) from $IFACE"

echo $LOG >> /var/log/dhcp.log

# if not exists this ip in /var/log/nmap
# scan it. if exists, and is older than 
# x, scan
# what else can we do..
