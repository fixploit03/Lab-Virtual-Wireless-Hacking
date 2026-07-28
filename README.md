# 🛜 lab-wifi

![License](https://img.shields.io/github/license/fixploit03/lab-wifi)
![Release](https://img.shields.io/github/v/release/fixploit03/lab-wifi)
![Issues](https://img.shields.io/github/issues/fixploit03/lab-wifi)
![Stars](https://img.shields.io/github/stars/fixploit03/lab-wifi)
![Last Commit](https://img.shields.io/github/last-commit/fixploit03/lab-wifi)

## Daftar Isi
- [Apa itu lab-wifi?](#apa-itu-lab-wifi)
- [Persyaratan](#persyaratan)
- [Topologi Lab](#topologi-lab)
- [Skenario Lab](#skenario-lab)
- [Cara Menggunakan Lab](#cara-menggunakan-lab)
- [Catatan](#catatan)
- [Disclaimer](#disclaimer)
- [Lisensi](#lisensi)

## Apa itu lab-wifi?

**lab-wifi** adalah lab virtual untuk simulasi *Wi-Fi hacking*, dibangun menggunakan [mac80211_hwsim](https://docs.kernel.org/6.1/networking/mac80211_hwsim/mac80211_hwsim.html), driver kernel Linux yang mensimulasikan perangkat wireless sepenuhnya lewat software, sehingga seluruh skenario bisa dijalankan tanpa membutuhkan perangkat Wi-Fi apa pun.

Lab ini mencakup berbagai skema keamanan Wi-Fi, mulai dari jaringan terbuka tanpa enkripsi (OPN), WPA2-Personal, WPA2-Enterprise, hingga WPA3-Personal, tanpa risiko menyentuh jaringan produksi atau milik orang lain. Karena seluruh proses berjalan di dalam VM, lab ini dapat digunakan berulang kali, di-reset kapan saja, dan tidak memerlukan izin dari pihak ketiga.

Cocok digunakan oleh pelajar, mahasiswa, praktisi keamanan siber, maupun siapa pun yang ingin memahami secara *hands-on* bagaimana kelemahan pada berbagai skema keamanan Wi-Fi dapat dieksploitasi.

## Persyaratan

| Kebutuhan | Spesifikasi |
|--|--|
| Perangkat | Laptop/PC |
| Software | VirtualBox 7.0+ |
| RAM host | 8 GB |
| CPU | 2 core |
| Storage | 30 GB (free space) |

## Topologi Lab

Lab terdiri dari 5 Access Point dengan skema keamanan yang berbeda-beda, yaitu OPN, WPA2-Personal, WPA2-Enterprise, WPA3 Transition Mode, dan WPA3-Personal. Setiap Access Point memiliki 1 Station (client) yang terhubung,

![](https://github.com/fixploit03/lab-wifi/blob/main/img/lab_wifi_topology.png)

## Skenario Lab

| No | Jenis Keamanan | Autentikasi | Hint |
|:--:|--|--|--|
| 1 | OPN | Tidak ada | [aircrack-ng](https://github.com/aircrack-ng/aircrack-ng) |
| 2 | WPA2-Personal | PSK | [aircrack-ng](https://github.com/aircrack-ng/aircrack-ng) |
| 3 | WPA2-Enterprise | EAP | [eaphammer](https://github.com/s0lst1c3/eaphammer) |
| 4 | WPA3 Transition Mode | PSK + SAE | [dragonshift](https://github.com/jabbaw0nky/DragonShift) |
| 5 | WPA3-Personal | SAE | [wacker](https://github.com/blunderbuss-wctf/wacker) |

## Cara Menggunakan Lab
1. Download semua file `.ova` yang ada di halaman [Release](https://github.com/fixploit03/lab-wifi/releases).
2. Gabungkan menjadi satu file:

   ```bash
   cat lab-wifi.ova.part-* > lab-wifi.ova
   ```
3. Import ke VirtualBox:
   - Buka VirtualBox → **File → Import Appliance**
   - Pilih file `lab-wifi.ova` hasil gabungan tadi
   - Ikuti wizard import sampai selesai
4. Jalankan VM:
   - Username: `lab-wifi`
   - Password: `lab-wifi`

## Catatan
Untuk menjalankan lab, dibutuhkan waktu beberapa menit saat boot, jadi mohon tunggu sampai prosesnya selesai.

## Disclaimer
Lab ini dibuat **semata-mata untuk tujuan pembelajaran, penelitian, dan meningkatkan kesadaran (awareness) terhadap keamanan jaringan Wi-Fi**.

Segala bentuk penyalahgunaan di luar tujuan tersebut sepenuhnya menjadi tanggung jawab pengguna.

## Lisensi
Project ini dirilis di bawah [MIT License](LICENSE).
