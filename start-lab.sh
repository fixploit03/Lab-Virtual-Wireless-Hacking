#!/bin/bash
#
# ------------------------------------------------------------------------------------------------
#
# + Lab Virtual Wireless Hacking
#
# + Github: https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/
# + Dibuat oleh: Rofi (Fixploit03)
# ------------------------------------------------------------------------------------------------

# cek root
if [[ $EUID -ne 0 ]]; then
        echo "Error: script ini harus dijalankan sebagai root!"
        exit 1
fi

echo -e "            ___      __   __  _     _  __   __            "
echo -e "           |   |    |  | |  || | _ | ||  | |  |           "
echo -e "           |   |    |  |_|  || || || ||  |_|  |           "
echo -e "           |   |    |       ||       ||       |           "
echo -e "           |   |___ |       ||       ||       |           "
echo -e "           |       | |     | |   _   ||   _   |           "
echo -e "           |_______|  |___|  |__| |__||__| |__|           "
echo -e ""
echo -e "               Lab Virtual Wireless Hacking               "
echo -e "https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking"
echo -e ""

# lepas modul
if lsmod | grep -q mac80211_hwsim; then
        modprobe -r mac80211_hwsim
fi

list_service=("hostapd" "dnsmasq" "wpa_supplicant" "dhclient" "freeradius" "NetworkManager")

# kill service
for service in "${list_service[@]}"; do
        if pgrep -x "${service}" > /dev/null; then
                if [[ "${service}" == "NetworkManager" ]]; then
                        systemctl stop "${service}"
                else
                        pkill -9 "${service}"
                fi
        fi
done

# ngaktifin modul
modprobe mac80211_hwsim radios=30
sleep 1

# ganti mac address
for i in $(seq 0 29); do
        ip l set "wlan${i}" down
    	macchanger -r "wlan${i}"
        ip l set "wlan${i}" up
done

# nama ns (network space)
ns="lab-wifi"

# hapus ns kalo udah ada
if ip netns l | grep -q "${ns}"; then
	ip netns d "${ns}"
fi

# bikin ns
ip netns a "${ns}"

# pindahin interface ke ns via phy
for i in $(seq 2 29); do
    interface="wlan${i}"
    phy=$(iw dev "${interface}" info | grep wiphy | awk '{print "phy"$2}')
    iw phy "${phy}" set netns name "${ns}"
done

# konfigurasi ip address
#
# wifi open
ip netns exec "${ns}" ip a a 10.10.1.1/24 dev wlan2
# wifi wpa-personal
ip netns exec "${ns}" ip a a 10.10.10.1/24 dev wlan6
# wifi wpa2-personal
ip netns exec "${ns}" ip a a 10.10.20.1/24 dev wlan10
# wifi wpa/wpa2-personal
ip netns exec "${ns}" ip a a 10.10.30.1/24 dev wlan14
# wifi wpa2-enterprise
ip netns exec "${ns}" ip a a 10.10.40.1/24 dev wlan18
# wifi wpa3-transition
ip netns exec "${ns}" ip a a 10.10.50.1/24 dev wlan22
# wifi wpa3-sae
ip netns exec "${ns}" ip a a 10.10.60.1/24 dev wlan26

ip netns exec "${ns}" ip l set lo up
ip netns exec "${ns}" freeradius

sleep 1

# jalanin ap
#
# wifi open
ip netns exec "${ns}" hostapd -B conf/opn/hostapd.conf
sleep 1
# wifi wpa-personal
ip netns exec "${ns}" hostapd -B conf/wpa-personal/hostapd.conf
sleep 1
# wifi wpa2-personal
ip netns exec "${ns}" hostapd -B conf/wpa2-personal/hostapd.conf
sleep 1
# wifi wpa/wpa2-personal
ip netns exec "${ns}" hostapd -B conf/wpa2-mixed/hostapd.conf
sleep 1
# wifi wpa2-enterprise
ip netns exec "${ns}" hostapd -B conf/wpa2-enterprise/hostapd.conf
sleep 1
# wifi wpa3-transition
ip netns exec "${ns}" hostapd -B conf/wpa3-transition/hostapd.conf
sleep 1
# wifi wpa3-sae
ip netns exec "${ns}" hostapd -B conf/wpa3-sae/hostapd.conf
sleep 1

# jalanin dhcp server
ip netns exec "${ns}" dnsmasq -C conf/dnsmasq.conf

# konek & minta ip buat wifi open
for i in $(seq 3 5); do
        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/opn/wpa_supplicant.conf -B -q
        sleep 1
        ip netns exec "${ns}" dhclient "wlan${i}"
done

# konek & minta ip buat wifi wpa-personal
for i in $(seq 7 9); do
        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/wpa-personal/wpa_supplicant.conf -B -q
        sleep 1
        ip netns exec "${ns}" dhclient "wlan${i}"
done

# konek & minta ip buat wifi wpa2-personal
for i in $(seq 11 13); do
        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/wpa2-personal/wpa_supplicant.conf -B -q
        sleep 1
        ip netns exec "${ns}" dhclient "wlan${i}"
done

# konek & minta ip buat wifi wpa/wpa2-personal
for i in $(seq 15 17); do
        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/wpa2-mixed/wpa_supplicant.conf -B -q
        sleep 1
        ip netns exec "${ns}" dhclient "wlan${i}"
done

# konek & minta ip buat wifi wpa2-enterprise
#
# Ucup
ip netns exec "${ns}" wpa_supplicant -D nl80211 -i wlan19 -c conf/wpa2-enterprise/ucup.conf -B -q
sleep 1
ip netns exec "${ns}" dhclient wlan19
#
# Adit
ip netns exec "${ns}" wpa_supplicant -D nl80211 -i wlan20 -c conf/wpa2-enterprise/adit.conf -B -q
sleep 1
ip netns exec "${ns}" dhclient wlan20
#
# Juned
ip netns exec "${ns}" wpa_supplicant -D nl80211 -i wlan21 -c conf/wpa2-enterprise/juned.conf -B -q
sleep 1
ip netns exec "${ns}" dhclient wlan21

# konek & minta ip buat wifi wpa3-transition
for i in $(seq 23 25); do
        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/wpa3-transition/wpa_supplicant.conf -B -q
        sleep 1
        ip netns exec "${ns}" dhclient "wlan${i}"
done

# konek & minta ip buat wifi wpa3-sae
for i in $(seq 27 29); do
        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/wpa3-sae/wpa_supplicant.conf -B -q
        sleep 1
        ip netns exec "${ns}" dhclient "wlan${i}"
done

echo -e "\n[+] OK."
exit 0
