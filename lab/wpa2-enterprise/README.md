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
