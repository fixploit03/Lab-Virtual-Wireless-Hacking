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
        sleep 3
fi

list_service=("hostapd" "dnsmasq" "wpa_supplicant")

# kill service
for service in "${list_service[@]}"; do
        if ps aux | grep -q "${service}"; then
                pkill -9 "${service}"
        fi
done

systemctl start NetworkManager

echo -e "\nOK."
exit 0
