#!/bin/bash
#
# Lab Wi-Fi WPA2-Enterprise
#
# https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/

if [[ $EUID -ne 0 ]]; then
        echo "Error: script ini harus dijalankan sebagai root!"
        exit 1
fi

# lepas modul
if lsmod | grep -q mac80211_hwsim; then
        modprobe -r mac80211_hwsim
        sleep 3
fi

list_service=("hostapd" "dnsmasq" "wpa_supplicant" "NetworkManager")

# kill service
for service in "${list_service[@]}"; do
        if ps aux | grep -q "${service}"; then
                if [[ "${service}" == "NetworkManager" ]]; then
                        systemctl stop "${service}"
                else
                        pkill -9 "${service}"
                fi
        fi
done

modprobe mac80211_hwsim radios=6
sleep 3

for i in $(seq 0 5); do
        ip l set "wlan${i}" down
        macchanger -r "wlan${i}"
        ip l set "wlan${i}" up
done

ip a add 192.168.10.1/24 dev wlan2

hostapd -B hostapd.conf
sleep 3
dnsmasq -C dnsmasq.conf
sleep 1.5

# Ucup
wpa_supplicant -D nl80211 -i wlan3 -c ucup.conf -B
sleep 3
dhclient wlan3
sleep 3

# Adit
wpa_supplicant -D nl80211 -i wlan4 -c adit.conf -B
sleep 3
dhclient wlan4
sleep 3

# Juned
wpa_supplicant -D nl80211 -i wlan5 -c juned.conf -B
sleep 3
dhclient wlan5
sleep 3

echo -e "\nOK."
exit 0
