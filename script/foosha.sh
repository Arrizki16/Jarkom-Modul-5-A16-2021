#!/bin/bash

iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source 192.168.122.2 -s 10.7.0.0/16

route add -net 10.7.7.128 netmask 255.255.255.248 gw 10.7.7.146
route add -net 10.7.7.0 netmask 255.255.255.128 gw 10.7.7.146
route add -net 10.7.0.0 netmask 255.255.252.0 gw 10.7.7.146

route add -net 10.7.4.0 netmask 255.255.254.0 gw 10.7.7.150
route add -net 10.7.7.136 netmask 255.255.255.248 gw 10.7.7.150
route add -net 10.7.6.0 netmask 255.255.255.0 gw 10.7.7.150

apt-get update

apt-get install isc-dhcp-relay -y

echo '
SERVERS="10.7.7.131"
INTERFACES="eth1 eth2"
OPTIONS=
' > /etc/default/isc-dhcp-relay

echo '
net.ipv4.ip_forward=1
' > /etc/sysctl.conf

service isc-dhcp-relay restart

service isc-dhcp-relay restart

iptables -A FORWARD -i eth0 -p tcp --dport 80 -d 10.7.7.128/29 -j DROP
