#!/bin/bash

conf_users="/etc/freeradius/3.0/users"
conf="conf/wpa2-enterprise/users"

if ! grep -q "ucup" "${conf_users}" || ! grep -q "adit" "${conf_users}" || ! grep -q "juned" "${conf_users}"; then
        cat "${conf}" >> "${conf_users}"
fi

systemctl stop freeradius

script=("start-lab" "stop-lab")

for s in "${script[@]}"; do
        chmod +x "${s}.sh"
done
         
