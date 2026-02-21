# Lab WPA2-Enterprise

```
sudo apt-get update
sudo apt-get install git iw hostapd dnsmasq wpasupplicant isc-dhcp-client freeradius aircrack-ng eaphammer
```

```
git clone https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/
cd Lab-Virtual-Wireless-Hacking/lab/wpa2-enterprise
chmod +x lab-wpa2-enterprise.sh
```

```
sudo cp /etc/freeradius/3.0/clients.conf /etc/freeradius/3.0/clients.conf.bak
sudo cp /etc/freeradius/3.0/users /etc/freeradius/3.0/users.bak
sudo cp /etc/freeradius/3.0/mods-available/eap /etc/freeradius/3.0/mods-available/eap.bak
sudo mv radius/clients.conf /etc/freeradius/3.0
sudo mv radius/users /etc/freeradius/3.0
sudo mv radius/eap /etc/freeradius/3.0/mods-available
```

```
sudo systemctl restart freeradius
sudo systemctl enable freeradius
```

```
sudo ./lab-wpa2-enterprise.sh
```
