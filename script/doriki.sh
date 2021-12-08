#!/bin/bash

echo '
nameserver 192.168.122.1
' > /etc/resolv.conf

apt-get update

apt-get install bind9 -y

echo '
options {
        directory "/var/cache/bind";

        forwarders {
                192.168.122.1;
        };

        // dnssec-validation auto;
        allow-query{ any; };
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
' > /etc/bind/named.conf.options

mkdir /etc/bind/test

echo '
zone "testing.com" {
        type master;
        file "/etc/bind/test/testing.com";
};
' > /etc/bind/named.conf.local

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     testing.com.    root.testing.com. (
                     2021120701         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      testing.com.
@       IN      A       10.7.7.140
@       IN      AAAA    ::1
' > /etc/bind/test/testing.com

service bind9 restart

service bind9 restart

iptables -A INPUT -p icmp -m connlimit --connlimit-above 3 --connlimit-mask 0 -j DROP

iptables -A INPUT -s 10.7.7.0/25,10.7.0.0/22 -m time --timestart 07:00 --timestop 15:00 --weekdays Mon,Tue,Wed,Thu -j ACCEPT
iptables -A INPUT -s 10.7.7.0/25,10.7.0.0/22 -m time --timestart 15:01 --timestop 00:00 --weekdays Mon,Tue,Wed,Thu -j DROP
iptables -A INPUT -s 10.7.7.0/25,10.7.0.0/22 -m time --timestart 00:01 --timestop 06:59 --weekdays Mon,Tue,Wed,Thu -j DROP
iptables -A INPUT -s 10.7.7.0/25,10.7.0.0/22 -m time --weekdays Sun,Fri,Sat -j DROP

iptables -A INPUT -s 10.7.4.0/23,10.7.6.0/24 -m time --timestart 15:01 --timestop 00:00 -j ACCEPT
iptables -A INPUT -s 10.7.4.0/23,10.7.6.0/24 -m time --timestart 00:01 --timestop 06:59 -j ACCEPT
iptables -A INPUT -s 10.7.4.0/23,10.7.6.0/24 -m time --timestart 07:00 --timestop 15:00 -j DROP