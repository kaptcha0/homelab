output "wan_bridge" {
  value = proxmox_virtual_environment_network_linux_bridge.wan.name
}

output "lan_bridge" {
  value = proxmox_virtual_environment_network_linux_bridge.lan.name
}
