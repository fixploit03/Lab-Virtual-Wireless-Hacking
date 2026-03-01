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

v="v1.0.1"

# cek root
if [[ $EUID -ne 0 ]]; then
        echo "Error: script ini harus dijalankan sebagai root!"
        exit 1
fi

# banner
echo -e "            ___      __   __  _     _  __   __            "
echo -e "           |   |    |  | |  || | _ | ||  | |  |           "
echo -e "           |   |    |  |_|  || || || ||  |_|  |           "
echo -e "           |   |    |       ||       ||       |           "
echo -e "           |   |___ |       ||       ||       |           "
echo -e "           |       | |     | |   _   ||   _   |           "
echo -e "           |_______|  |___|  |__| |__||__| |__| ${v}      "
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
        if pgrep -x "${service}" &>/dev/null; then
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
network_space=(
        "opn"
        "wpa-personal"
        "wpa2-personal"
        "wpa-wpa2-personal"
        "wpa2-enterprise"
        "wpa3-transition"
        "wpa3-sae"
)

# konfigurasi ns
for ns in "${network_space[@]}"; do
        # hapus ns kalo udah ada
        if ip netns l | grep -q "${ns}"; then
                ip netns d "${ns}"
        fi

        # bikin ns
        ip netns a "${ns}"
        ip netns exec "${ns}" ip l set lo up

        # wifi open
        if [[ "${ns}" == "opn" ]]; then
                for i in $(seq 2 5); do
                        interface="wlan${i}"
                        phy=$(iw dev "${interface}" info | grep wiphy | awk '{print "phy"$2}')
                        iw phy "${phy}" set netns name "${ns}"
                done
                ip netns exec "${ns}" ip a a 10.10.1.1/24 dev wlan2
                ip netns exec "${ns}" hostapd -B conf/opn/hostapd.conf
                sleep 1
                ip netns exec "${ns}" dnsmasq -C conf/opn/dnsmasq.conf
                for i in $(seq 3 5); do
                        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/opn/wpa_supplicant.conf -B -q
                        sleep 1
                        ip netns exec "${ns}" dhclient "wlan${i}"
                        ip netns exec "${ns}" bash -c "
                                while true; do
                                        ping -I "wlan${i}" 10.10.1.1 -c 1 -q &>/dev/null
                                        sleep 1
                                done &
                        "
                done
        # wifi wpa-personal
        elif [[ "${ns}" == "wpa-personal" ]]; then
                for i in $(seq 6 9); do
                        interface="wlan${i}"
                        phy=$(iw dev "${interface}" info | grep wiphy | awk '{print "phy"$2}')
                        iw phy "${phy}" set netns name "${ns}"
                done
                ip netns exec "${ns}" ip a a 10.10.10.1/24 dev wlan6
                ip netns exec "${ns}" hostapd -B conf/wpa-personal/hostapd.conf
                sleep 1
                ip netns exec "${ns}" dnsmasq -C conf/wpa-personal/dnsmasq.conf
                for i in $(seq 7 9); do
                        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/wpa-personal/wpa_supplicant.conf -B -q
                        sleep 1
                        ip netns exec "${ns}" dhclient "wlan${i}"
                        ip netns exec "${ns}" bash -c "
                                while true; do
                                        ping -I "wlan${i}" 10.10.10.1 -c 1 -q &>/dev/null
                                        sleep 1
                                done &
                        "
                done
        # wifi wpa2-personal
        elif [[ "${ns}" == "wpa2-personal" ]]; then
                for i in $(seq 10 13); do
                        interface="wlan${i}"
                        phy=$(iw dev "${interface}" info | grep wiphy | awk '{print "phy"$2}')
                        iw phy "${phy}" set netns name "${ns}"
                done
                ip netns exec "${ns}" ip a a 10.10.20.1/24 dev wlan10
                ip netns exec "${ns}" hostapd -B conf/wpa2-personal/hostapd.conf
                sleep 1
                ip netns exec "${ns}" dnsmasq -C conf/wpa2-personal/dnsmasq.conf
                for i in $(seq 11 13); do
                        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/wpa2-personal/wpa_supplicant.conf -B -q
                        sleep 1
                        ip netns exec "${ns}" dhclient "wlan${i}"
                        ip netns exec "${ns}" bash -c "
                                while true; do
                                        ping -I "wlan${i}" 10.10.20.1 -c 1 -q &>/dev/null
                                        sleep 1
                                done &
                        "
                done
        # wifi wpa/wpa2-personal
        elif [[ "${ns}" == "wpa-wpa2-personal" ]]; then
                for i in $(seq 14 17); do
                        interface="wlan${i}"
                        phy=$(iw dev "${interface}" info | grep wiphy | awk '{print "phy"$2}')
                        iw phy "${phy}" set netns name "${ns}"
                done
                ip netns exec "${ns}" ip a a 10.10.30.1/24 dev wlan14
                ip netns exec "${ns}" hostapd -B conf/wpa2-mixed/hostapd.conf
                sleep 1
                ip netns exec "${ns}" dnsmasq -C conf/wpa2-mixed/dnsmasq.conf
                for i in $(seq 15 17); do
                        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/wpa2-mixed/wpa_supplicant.conf -B -q
                        sleep 1
                        ip netns exec "${ns}" dhclient "wlan${i}"
                        ip netns exec "${ns}" bash -c "
                                while true; do
                                        ping -I "wlan${i}" 10.10.30.1 -c 1 -q &>/dev/null
                                        sleep 1
                                done &
                        "
                done
        # wifi wpa2-enterprise
        elif [[ "${ns}" == "wpa2-enterprise" ]]; then
                for i in $(seq 18 21); do
                        interface="wlan${i}"
                        phy=$(iw dev "${interface}" info | grep wiphy | awk '{print "phy"$2}')
                        iw phy "${phy}" set netns name "${ns}"
                done
                ip netns exec "${ns}" ip a a 10.10.40.1/24 dev wlan18
                ip netns exec "${ns}" freeradius
                ip netns exec "${ns}" hostapd -B conf/wpa2-enterprise/hostapd.conf
                sleep 1
                ip netns exec "${ns}" dnsmasq -C conf/wpa2-enterprise/dnsmasq.conf

                # Ucup
                ip netns exec "${ns}" wpa_supplicant -D nl80211 -i wlan19 -c conf/wpa2-enterprise/ucup.conf -B -q
                sleep 1
                ip netns exec "${ns}" dhclient wlan19
                ip netns exec "${ns}" bash -c "
                        while true; do
                                ping -I wlan19 10.10.40.1 -c 1 -q &>/dev/null
                                sleep 1
                        done &
                "
                #
                # Adit
                ip netns exec "${ns}" wpa_supplicant -D nl80211 -i wlan20 -c conf/wpa2-enterprise/adit.conf -B -q
                sleep 1
                ip netns exec "${ns}" dhclient wlan20
                ip netns exec "${ns}" bash -c "
                        while true; do
                                ping -I wlan20 10.10.40.1 -c 1 -q &>/dev/null
                                sleep 1
                        done &
                "
                #
                # Juned
                ip netns exec "${ns}" wpa_supplicant -D nl80211 -i wlan21 -c conf/wpa2-enterprise/juned.conf -B -q
                sleep 1
                ip netns exec "${ns}" dhclient wlan21
                ip netns exec "${ns}" bash -c "
                        while true; do
                                ping -I wlan21 10.10.40.1 -c 1 -q &>/dev/null
                                sleep 1
                        done &
                "
        # wifi wpa3-transition
        elif [[ "${ns}" == "wpa3-transition" ]]; then
                for i in $(seq 22 25); do
                        interface="wlan${i}"
                        phy=$(iw dev "${interface}" info | grep wiphy | awk '{print "phy"$2}')
                        iw phy "${phy}" set netns name "${ns}"
                done
                ip netns exec "${ns}" ip a a 10.10.50.1/24 dev wlan22
                ip netns exec "${ns}" hostapd -B conf/wpa3-transition/hostapd.conf
                sleep 1
                ip netns exec "${ns}" dnsmasq -C conf/wpa3-transition/dnsmasq.conf
                for i in $(seq 23 25); do
                        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/wpa3-transition/wpa_supplicant.conf -B -q
                        sleep 1
                        ip netns exec "${ns}" dhclient "wlan${i}"
                        ip netns exec "${ns}" bash -c "
                                while true; do
                                        ping -I "wlan${i}" 10.10.50.1 -c 1 -q &>/dev/null
                                        sleep 1
                                done &
                        "
                done
        # wifi wpa3-sae
        elif [[ "${ns}" == "wpa3-sae" ]]; then
                for i in $(seq 26 29); do
                        interface="wlan${i}"
                        phy=$(iw dev "${interface}" info | grep wiphy | awk '{print "phy"$2}')
                        iw phy "${phy}" set netns name "${ns}"
                done
                ip netns exec "${ns}" ip a a 10.10.60.1/24 dev wlan26
                ip netns exec "${ns}" hostapd -B conf/wpa3-sae/hostapd.conf
                sleep 1
                ip netns exec "${ns}" dnsmasq -C conf/wpa3-sae/dnsmasq.conf
                for i in $(seq 27 29); do
                        ip netns exec "${ns}" wpa_supplicant -D nl80211 -i "wlan${i}" -c conf/wpa3-sae/wpa_supplicant.conf -B -q
                        sleep 1
                        ip netns exec "${ns}" dhclient "wlan${i}"
                        ip netns exec "${ns}" bash -c "
                                while true; do
                                        ping -I "wlan${i}" 10.10.60.1 -c 1 -q &>/dev/null
                                        sleep 1
                                done &
                        "
                done
        fi
done

echo -e "\n[+] OK."
exit 0
