#!/bin/bash

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
