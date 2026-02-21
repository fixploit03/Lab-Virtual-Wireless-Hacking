#!/bin/bash
#
# Lab Wi-Fi WPA2-Personal
#
# https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/

if [[ $EUID -ne 0 ]]; then
        echo "Error: script ini harus dijalankan sebagai root!"
        exit 1
fi

# lepas modul
if lsmod | grep -q mac80211_hwsim; then
        modprobe -r mac80211_hwsim
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

modprobe mac80211_hwsim radios=5
sleep 3

for i in $(seq 0 4); do
        ip l set "wlan${i}" down
        macchanger -r "wlan${i}"
        ip l set "wlan${i}" up
done

ip a add 10.10.10.1/24 dev wlan1

hostapd -B hostapd.conf
sleep 3
dnsmasq -C dnsmasq.conf
sleep 1.5

for i in $(seq 2 4); do
        wpa_supplicant -D nl80211 -i "wlan${i}" -c wpa_supplicant.conf -B
        sleep 3
        dhclient "wlan${i}"
        sleep 3
done

echo -e "\nOK."
exit 0
