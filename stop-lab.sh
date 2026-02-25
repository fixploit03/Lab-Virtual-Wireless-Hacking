#!/bin/bash
#
# ------------------------------------------------------------------------------------------------
#
# + Lab Virtual Wireless Hacking
#
# + Github: https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/
# + Dibuat oleh: Rofi (Fixploit03)
#
# ------------------------------------------------------------------------------------------------

if [[ $EUID -ne 0 ]]; then
        echo "Error: script ini harus dijalankan sebagai root!"
        exit 1
fi

list_service=("hostapd" "dnsmasq" "wpa_supplicant" "dhclient" "freeradius")

# kill service
for service in "${list_service[@]}"; do
        if pgrep -x "${service}" &>/dev/null; then
                pkill -9 "${service}"
        fi
done

# nama ns (network space)
network_space=(
        "opn"
        "wpa-personal"
        "wpa2-personal"
        "wpa-wpa2-personal"
        "wpa2-enterprise"
        "wpa3-transition"
        "wpa3-sae"
)

# hapus ns
for ns in "${network_space[@]}"; do
	if ip netns l | grep -q "${ns}"; then
	        ip netns d "${ns}"
	fi
done

# lepas modul
if lsmod | grep -q mac80211_hwsim; then
        modprobe -r mac80211_hwsim
        sleep 1
fi

# start networkmanager
systemctl start NetworkManager

echo -e "\n[+] OK."
exit 0
