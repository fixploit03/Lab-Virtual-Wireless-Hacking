# NS (Network Space)

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
