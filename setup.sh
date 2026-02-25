#!/bin/bash

# cek root
if [[ $EUID -ne 0 ]]; then
        echo "Error: script ini harus dijalankan sebagai root!"
        exit 1
fi

# update repositori linux
apt-get update -y

# instal tools
tools=("macchanger" "dnsmasq" "wpa_supplicant" "iw" "freeradius" "dhclient")

for t in "${tools[@]}"; do
        if ! command -v "${t}" &>/dev/null; then
                if [[ "${t}" == "wpa_supplicant" ]]; then
                        apt-get install wpasupplicant -y
                        continue
                elif [[ "${t}" == "dhclient" ]]; then
                        apt-get install isc-dhcp-client -y
                        continue
                else
                        apt-get install "${t}" -y
                fi
        fi
done

path="/usr/sbin"
file=("hostapd" "hostapd_cli")

# kalo ada file bakal di backup
for f in "${file[@]}"; do
        if [[ -f "${path}/${f}" ]]; then
                mv "${path}/${f}" "${path}/${f}.bak"
        fi
done

# ekstrak hostapd
tar -zxf hostapd/hostapd-2.11.tar.gz -C hostapd

# pindahin hostapd ke direktori '/usr/sbin'
cp hostapd/hostapd "${path}"
cp hostapd/hostapd_cli "${path}"

conf_users="/etc/freeradius/3.0/users"
conf="conf/wpa2-enterprise/users"

# cek kalo kaga ada user 'ucup, adit, sama juned' bakal nambahin ke config users freeradius
if ! grep -q "ucup" "${conf_users}" || ! grep -q "adit" "${conf_users}" || ! grep -q "juned" "${conf_users}"; then
        cat "${conf}" >> "${conf_users}"
fi

# stop service freeradius
systemctl stop freeradius

script=("start-lab" "stop-lab")

# beri izin eksekusi
for s in "${script[@]}"; do
        chmod +x "${s}.sh"
done
         
hash -r
