# Proxmox Initial Config

## Management WiFi
`/etc/hostapd/hostapd.conf`
```conf
interface=wlp3s0
bridge=vmbr2
driver=nl80211
ssid=pve-mgmt
hw_mode=g
channel=6
wmm_enabled=1
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=[...]
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
```

```sh
systemctl enable hostapd
systemctl start hostapd
brctl stp vmbr2 on
ip link set dev vmbr2 up
```