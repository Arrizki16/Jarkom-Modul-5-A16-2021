#!/bin/bash

echo '
nameserver 192.168.122.1
' > /etc/resolv.conf

apt-get update

apt-get install isc-dhcp-relay -y

echo '
SERVERS="10.7.7.131"
INTERFACES="eth0 eth1 eth2 eth3"
OPTIONS=
' > /etc/default/isc-dhcp-relay

echo '
net.ipv4.ip_forward=1
' > /etc/sysctl.conf

service isc-dhcp-relay restart

service isc-dhcp-relay restart

iptables -t nat -A PREROUTING -d 10.7.7.140 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 10.7.7.138
iptables -t nat -A PREROUTING -d 10.7.7.140 -j DNAT --to-destination 10.7.7.139
