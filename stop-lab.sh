#!/bin/bash
#
# ------------------------------------------------------------------------------------------------
#
# + Lab Virtual Wireless Hacking
#
# + Github: https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/
# + Dibuat oleh: Rofi (Fixploit03)
# ------------------------------------------------------------------------------------------------

if [[ $EUID -ne 0 ]]; then
        echo "Error: script ini harus dijalankan sebagai root!"
        exit 1
fi

ns="lab-wifi"

list_service=("hostapd" "dnsmasq" "wpa_supplicant" "dhclient" "freeradius")

# kill service
for service in "${list_service[@]}"; do
        if pgrep -x "${service}" > /dev/null; then
                pkill -9 "${service}"
        fi
done

# hapus ns
if ip netns l | grep -q "${ns}"; then
        ip netns d "${ns}"
fi

# lepas modul
if lsmod | grep -q mac80211_hwsim; then
        modprobe -r mac80211_hwsim
        sleep 1
fi

# start networkmanager
systemctl start NetworkManager

echo -e "\n[+] OK."
exit 0
