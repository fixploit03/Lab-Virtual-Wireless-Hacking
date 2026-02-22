# Lab Wi-Fi WPA2-Enterprise

## Konfigurasi Interface
- `wlan0`: Rogue AP
- `wlan1`: Deauth
- `wlan2`: AP & DHCP Server
- `wlan3` - `wlan5`: STA
  
## Konfigurasi FreeRADIUS

```
sudo tee -a /etc/freeradius/3.0/users < users
sudo mv eap /etc/freeradius/3.0/mods-available/
sudo systemctl restart freeradius
sudo systemctl enable freeradius
radtest ucup ucup123 127.0.0.1 1812 testing123
radtest adit adit123 127.0.0.1 1812 testing123
radtest juned juned123 127.0.0.1 1812 testing123
```

> [!note]
> Konfigurasi FreeRADIUS hanya perlu dilakukan satu kali.

## Instalasi

Instal tools yang dibutuhkan:

```
sudo apt-get update
sudo apt-get install git iw hostapd dnsmasq wpasupplicant isc-dhcp-client freeradius aircrack-ng eaphammer john hashcat
```

Kloning repositori:

```
git clone https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking
cd Lab-Virtual-Wireless-Hacking/lab/wpa2-personal
```

Beri izin eksekusi:

```
chmod +x start-lab.sh stop-lab.sh
```

Jalankan lab:

```
sudo ./start-lab.sh
```

Stop lab:

```
sudo ./stop-lab.sh
```
