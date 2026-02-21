#!/bin/bash
#
# ----------------------------------------------
# WPA2-Enterprise
# ----------------------------------------------
# Konfigurasi interface (6)
#
# wlan0         = buat eaphammer
# wlan1         = buat deauth
# wlan2         = buat AP
# wlan3 - wlan5 = buat STA (client)
#
# ----------------------------------------------

modprobe mac80211_hwsim radios=6
sleep 2

systemctl stop NetworkManager
systemctl stop wpa_supplicant
sleep 2

for i in $(seq 0 5); do
        ip link set "wlan${i}" down
        macchanger -r "wlan${i}"
        ip link set "wlan${i}" up
done

ip addr add 10.10.10.1/29 dev wlan2

hostapd conf/hostapd.conf -B
sleep 2

dnsmasq -C conf/dnsmasq.conf
sleep 2

# Ucup
wpa_supplicant -D nl80211 -i wlan3 -c conf/ucup.conf -B
sleep 2
dhclient wlan3

# Adit
wpa_supplicant -D nl80211 -i wlan4 -c conf/adit.conf -B
sleep 2
dhclient wlan4

# Juned
wpa_supplicant -D nl80211 -i wlan5 -c conf/ucup.conf -B
sleep 2
dhclient wlan5
