#!/bin/bash

apt-get update

apt-get install isc-dhcp-server -y

echo '
INTERFACES="eth0"
' > /etc/default/isc-dhcp-server

echo '
subnet 10.7.7.128 netmask 255.255.255.248 {
}

subnet 10.7.7.0 netmask 255.255.255.128 {
    range 10.7.7.2 10.7.7.126;
    option routers 10.7.7.1;
    option broadcast-address 10.7.7.127;
    option domain-name-servers 10.7.7.130;
}

subnet 10.7.0.0 netmask 255.255.252.0 {
    range 10.7.0.2 10.7.3.254;
    option routers 10.7.0.1;
    option broadcast-address 10.7.3.255;
    option domain-name-servers 10.7.7.130;
}

subnet 10.7.6.0 netmask 255.255.255.0 {
    range 10.7.6.2 range 10.7.6.254;
    option routers 10.7.6.1;
    option broadcast-address 10.7.6.255;
    option domain-name-servers 10.7.7.130;
}

subnet 10.7.4.0 netmask 255.255.254.0 {
    range 10.7.4.2 10.7.5.254;
    option routers 10.7.4.1;
    option broadcast-address 10.7.5.255;
    option domain-name-servers 10.7.7.130;
}
' > /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart

service isc-dhcp-server restart

iptables -A INPUT -p icmp -m connlimit --connlimit-above 3 --connlimit-mask 0 -j DROP
