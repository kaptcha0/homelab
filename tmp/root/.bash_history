systemctl status k3s.service 
pidof k3s
exit
systemctl status k3
systemctl status k3s
exit
# Save all iptables rules (all tables)
sudo iptables-save > iptables-filter.txt
sudo iptables -t nat -L -n -v > iptables-nat.txt
sudo iptables -t mangle -L -n -v > iptables-mangle.txt
sudo nft list ruleset > nftables.txt 2>/dev/null || echo "nftables not in use"
ls
pwd
exit
