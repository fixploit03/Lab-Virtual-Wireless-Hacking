# NS (Network Space)
NS (Network Namespace) adalah fitur di Linux untuk membuat lingkungan jaringan yang terisolasi. Di dalamnya bisa punya interface, routing table, dan firewall rules sendiri yang benar-benar terpisah dari host maupun namespace lain, sehingga setiap namespace seolah-olah berjalan di mesin dengan jaringan yang berbeda.

## Konfigurasi

Buat NS:

```
sudo ip netns add [ns]
```

Lihat NS:

```
ip netns list
```

Pindahkan interface ke NS:

```
iw dev [interface] info
sudo iw phy [phy] set netns name [ns]
```

Masuk ke shell NS:

```
sudo ip netns exec [ns] [shell]
```

Konfigurasi...

## Cleanup

Kembalikan interface ke host:

```
sudo ip netns exec [ns] ip link set [interface] netns 1
```

Hapus NS:

```
sudo ip netns del [ns]
```
