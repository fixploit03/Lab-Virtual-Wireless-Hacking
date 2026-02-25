#!/bin/bash

# update repositori linux
apt-get update -y

# list dependensi
dependensi=(
	"build-essential"
	"pkg-config"
	"libssl-dev"
	"libnl-3-dev"
	"libnl-genl-3-dev"
	"libnl-route-3-dev"
)

# instal dependensi
for d in "${dependensi[@]}"; do
  apt-get install "${d}" -y
done

tar -zxf hostapd-2.11.tar.gz
cd hostapd-2.11/hostapd
make -j$(nproc)
make install SBINDIR=/usr/sbin BINDIR=/usr/sbin
