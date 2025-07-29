# 2025-08-01 22:03:28 by RouterOS 7.19.3
# system id = lQ0EkzwUbqO
#
/interface bridge
add name=lan-bridge vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
/interface vlan
add interface=lan-bridge name=vlan99 vlan-id=99
/ip pool
add name=pool99 ranges=10.67.99.100-10.67.99.200
/port
set 0 name=serial0
/interface bridge port
add bridge=lan-bridge interface=ether3 pvid=99
/interface bridge vlan
add bridge=lan-bridge tagged=lan-bridge untagged=ether3 vlan-ids=99
/ip address
add address=10.67.99.1/24 interface=vlan99 network=10.67.99.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server
add address-pool=pool99 interface=vlan99 name=dhcp99
/ip dhcp-server network
add address=10.67.99.0/24 gateway=10.67.99.1
/ip service
set www-ssl certificate=webfig disabled=no
