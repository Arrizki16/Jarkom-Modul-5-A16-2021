# Jarkom-Modul-5-A16-2021
Lapres Praktikum Jarkom Modul 5  
kelompok A16 : Deka Julian Arrizki  

## **Konten**
* [**Cara Pengerjaan**](#cara-pengerjaan)
* [**Kendala**](#kendala)

## Cara Pengerjaan
### Subnetting (VLSM)

| Host | Jumlah | Network ID | IP Range | Broadcast | Netmask
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | 
| CHIPER | 701 | 10.7.0.0 | 10.7.0.1 - 10.7.3.254 | 10.7.3.255 | 255.255.252.0 |
| ELENA | 301 | 10.7.4.0 | 10.7.4.1 - 10.7.5.254 | 10.7.5.255 | 255.255.254.0 |
| FUKUROU | 201 | 10.7.6.0 | 10.7.6.1 - 10.7.6.254 | 10.7.6.255 | 255.255.255.0 |
| BLUENO | 101 | 10.7.7.0 | 10.7.7.1 - 10.7.7.126 | 10.7.7.127 | 255.255.255.128 |
| WATER7-SERVER | 3 | 10.7.7.128 | 10.7.7.129 - 10.7.7.134 | 10.7.7.135 | 255.255.255.248 |
| GUANHAO-SERVER | 3 | 10.7.7.136 | 10.7.7.137 - 10.7.7.142 | 10.7.7.143 | 255.255.255.248 |
| WATER7-FOOSHA | 2 | 10.7.7.144 | 10.7.7.145 - 10.7.7.146 | 10.7.7.147 | 255.255.255.252 |
| GUANHAO-FOOSHA | 2 | 10.7.7.148 | 10.7.7.149 - 10.7.7.150 | 10.7.7.151 | 255.255.255.25 |

### Konfigurasi Interface
* FOOSHA
```
auto eth0
iface eth0 inet static
	address 192.168.122.2
	netmask 255.255.255.252
        gateway 192.168.122.1
        up echo nameserver 192.168.122.1 > /etc/resolv.conf

auto eth1
iface eth1 inet static
	address 10.7.7.149
	netmask 255.255.255.252

auto eth2
iface eth2 inet static
	address 10.7.7.145
	netmask 255.255.255.252
```
* WATER7
```
auto eth0
iface eth0 inet static
	address 10.7.7.146
	netmask 255.255.255.252
        gateway 10.7.7.145
        up echo nameserver 192.168.122.1 > /etc/resolv.conf

auto eth1
iface eth1 inet static
	address 10.7.7.1
	netmask 255.255.255.128

auto eth2
iface eth2 inet static
	address 10.7.7.129
	netmask 255.255.255.248

auto eth3
iface eth3 inet static
	address 10.7.0.1
	netmask 255.255.252.0
```
* GUANHAO
```
auto eth0
iface eth0 inet static
	address 10.7.7.150
	netmask 255.255.255.252
        gateway 10.7.7.149
        up echo nameserver 192.168.122.1 > /etc/resolv.conf

auto eth1
iface eth1 inet static
	address 10.7.4.1
	netmask 255.255.254.0

auto eth2
iface eth2 inet static
	address 10.7.7.137
	netmask 255.255.255.248

auto eth3
iface eth3 inet static
	address 10.7.6.1
	netmask 255.255.255.0
```
* DORIKI
```
auto eth0
iface eth0 inet static
	address 10.7.7.130
	netmask 255.255.255.248
	gateway 10.7.7.129
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
* JIPANGU
```
auto eth0
iface eth0 inet static
	address 10.7.7.131
	netmask 255.255.255.248
	gateway 10.7.7.129
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
* JORGE
```
auto eth0
iface eth0 inet static
	address 10.7.7.138
	netmask 255.255.255.248
	gateway 10.7.7.137
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
* MAINGATE
```
auto eth0
iface eth0 inet static
	address 10.7.7.139
	netmask 255.255.255.248
	gateway 10.7.7.137
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
* Semua Client
```
auto eth0
iface eth0 inet dhcp
```

### Routing
* FOOSHA
```
route add -net 10.7.7.128 netmask 255.255.255.248 gw 10.7.7.146
route add -net 10.7.7.0 netmask 255.255.255.128 gw 10.7.7.146
route add -net 10.7.0.0 netmask 255.255.252.0 gw 10.7.7.146

route add -net 10.7.4.0 netmask 255.255.254.0 gw 10.7.7.150
route add -net 10.7.7.136 netmask 255.255.255.248 gw 10.7.7.150
route add -net 10.7.6.0 netmask 255.255.255.0 gw 10.7.7.150
```


### IP DHCP
* Konfigurasi pada JIPANGU ```/etc/default/isc-dhcp-server``` mengarah dari interface JIPANGU ke Water7
```
INTERFACES="eth0"
```
* Konfigurasi pada JIPANGU ```/etc/dhcp/dhcpd.conf``` untuk IP DHCP tiap subnet client
```
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
```

### NOMOR 1
* FOOSHA  

Menambahkan iptables pada interface ```eth0``` yang memiliki ip ```192.168.122.2``` di FOOSHA
```
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source 192.168.122.2 -s 10.7.0.0/16
```
### NOMOR 2
* FOOSHA
```
iptables -A FORWARD -i eth0 -p tcp --dport 80 -d 10.7.7.128/29 -j DROP
```
* Testing
Testing dengan menggunakan nmap ```nmap -p 80 10.7.7.130``` pada semua host selain ip 10.7.7.130. Jika semua hasilnya tidak ```filtered``` maka sudah benar. Contoh dibawah ini hanya saya berikan dari 3 host saja :)  
![image](https://user-images.githubusercontent.com/55046884/145218693-07c01d3a-8452-4f68-8679-d04d34381f71.png)  
![image](https://user-images.githubusercontent.com/55046884/145218744-a5eca87d-8bc1-4715-beba-a09b771a697f.png)  
![image](https://user-images.githubusercontent.com/55046884/145218806-92de0a0f-836c-4ce6-9061-16d621ef6539.png)  

### NOMOR 3
* JIPANGU & DORIKI
Iptables menerapkan fungsi conlimit untuk jumlah host (3) dan panjang prefix (21)
```
iptables -A INPUT -p icmp -m connlimit --connlimit-above 3 --connlimit-mask 21 -j DROP
```
* Testing
Host 1  
![image](https://user-images.githubusercontent.com/55046884/145219797-5822597f-c5d3-4bcb-8347-883a4c1a078d.png)  
Host 2  
![image](https://user-images.githubusercontent.com/55046884/145219849-2866dc0e-633c-44e0-80bf-a80c40bfbcda.png)  
Host 3  
![image](https://user-images.githubusercontent.com/55046884/145219922-e7cbad45-e414-4bfe-ab8e-21b5ccd3d6cf.png)  
Host 4  
![image](https://user-images.githubusercontent.com/55046884/145219967-6d5ed913-1b0c-4e59-8909-cc01273ec82d.png)  

### NOMOR 4
* DORIKI
Konfigurasi ini ditulis lebih lengkap, kalau disingkat juga boleh :)
```
iptables -A INPUT -s 10.7.7.0/25,10.7.0.0/22 -m time --timestart 07:00 --timestop 15:00 --weekdays Mon,Tue,Wed,Thu -j ACCEPT
iptables -A INPUT -s 10.7.7.0/25,10.7.0.0/22 -m time --timestart 15:01 --timestop 00:00 --weekdays Mon,Tue,Wed,Thu -j DROP
iptables -A INPUT -s 10.7.7.0/25,10.7.0.0/22 -m time --timestart 00:01 --timestop 06:59 --weekdays Mon,Tue,Wed,Thu -j DROP
iptables -A INPUT -s 10.7.7.0/25,10.7.0.0/22 -m time --weekdays Sun,Fri,Sat -j DROP
```
* Testing  

Date = ```Thu Dec  9 06:14:27 UTC 2021```  
  
BLUENO  
![image](https://user-images.githubusercontent.com/55046884/145220501-395b36db-cebe-4356-a38a-9b0818fc86a5.png)  
CHIPER  
![image](https://user-images.githubusercontent.com/55046884/145220550-4a9c50ba-9d3b-4e60-85a6-bcd8e71ba00a.png)  
  
Date = ```Wed Dec  8 07:59:00 UTC 2021```  
  
BLUENO  
![image](https://user-images.githubusercontent.com/55046884/145220705-9c5de528-73be-4e5c-ad65-6ef4e6d97565.png)  
CHIPER  
![image](https://user-images.githubusercontent.com/55046884/145220764-52a1283d-81b6-4839-a8be-6c90e3e6d90c.png)  

### NOMOR 5
* DORIKI
Sama kayak no 4, konfigurasi ini versi lengkap kalau mau disingkat halal kok :)
```
iptables -A INPUT -s 10.7.4.0/23,10.7.6.0/24 -m time --timestart 15:01 --timestop 00:00 -j ACCEPT
iptables -A INPUT -s 10.7.4.0/23,10.7.6.0/24 -m time --timestart 00:01 --timestop 06:59 -j ACCEPT
iptables -A INPUT -s 10.7.4.0/23,10.7.6.0/24 -m time --timestart 07:00 --timestop 15:00 -j DROP
```
* Testing

Date = ```Thu Dec  9 07:05:00 UTC 2021```

ELENA  
![image](https://user-images.githubusercontent.com/55046884/145221439-be0658df-c860-4261-b4c6-4c6884e38185.png)  
FUKUROU  
![image](https://user-images.githubusercontent.com/55046884/145221502-dce1461f-5fe8-4dc7-9813-7127b0a110f9.png)  

Date = ```Thu Dec  9 06:05:00 UTC 2021```

ELENA  
![image](https://user-images.githubusercontent.com/55046884/145221628-6f43e35f-7af6-4763-9d6c-74025e3d9b0e.png)  
FUKUROU  
![image](https://user-images.githubusercontent.com/55046884/145221709-02973ad4-06f5-4491-9a1c-364fdef1f4c2.png)  

### NOMOR 6
* DORIKI
Membuat domain random terlebih dahulu sebagai testing
```/etc/bind/named.conf.local```
```
zone "testing.com" {
        type master;
        file "/etc/bind/test/testing.com";
};
```
```/etc/bind/test/testing.com```
```
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
```
* GUANHAO
```
iptables -t nat -A PREROUTING -d 10.7.7.140 -m state --state NEW -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 10.7.7.138
iptables -t nat -A PREROUTING -d 10.7.7.140 -j DNAT --to-destination 10.7.7.139
```
* TESTING  

![image](https://user-images.githubusercontent.com/55046884/145222865-57601bce-6285-4aec-93ea-5a406dee60b8.png)  
![image](https://user-images.githubusercontent.com/55046884/145222974-620b741e-2d51-43f4-8a5b-ea0fa0097df2.png)  
![image](https://user-images.githubusercontent.com/55046884/145223202-a743746f-02b0-4833-91cb-e11dcda7c279.png)  
![image](https://user-images.githubusercontent.com/55046884/145223419-6052a867-bc0c-458e-b5df-b5628f6c587f.png)  

## KENDALA
