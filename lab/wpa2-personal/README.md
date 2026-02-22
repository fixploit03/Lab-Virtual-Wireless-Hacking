# Lab Wi-Fi WPA2-Personal

## Konfigurasi Interface
- `wlan0`: Attacker
- `wlan1`: AP & DHCP Server
- `wlan2` - `wlan4`: STA

## Instal Tools

```
sudo apt-get update
sudo apt-get install iw hostapd dnsmasq wpasupplicant isc-dhcp-client aircrack-ng
```

## Kloning Repositori

```
git clone https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking
cd Lab-Virtual-Wireless-Hacking/lab/wpa2-personal
chmod +x start-lab.sh stop-lab.sh
```

## Jalankan Lab

```
sudo ./start-lab.sh
```

## Screenshot

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/wpa2-personal.png)
![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/airodump-ng.png)

## Stop Lab

```
sudo ./stop-lab.sh
```
