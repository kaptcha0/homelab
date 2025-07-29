resource "proxmox_virtual_environment_network_linux_bridge" "wan" {
  node_name = local.pm_node
  name      = "vmbr0"

  comment = "WAN ${var.default_comment}"

  ports = [
    "eno1"
  ]
}

resource "proxmox_virtual_environment_network_linux_bridge" "lan" {
  node_name = local.pm_node
  name      = "vmbr1"
  comment   = "LAN ${var.default_comment}"

  vlan_aware = true

  ports = [
    "enx00051b2a4e43"
  ]
}

resource "proxmox_virtual_environment_network_linux_vlan" "mgmt_vlan" {
  node_name = local.pm_node
  name      = "${proxmox_virtual_environment_network_linux_bridge.lan.name}.${module.shared.management_vlan.id}"

  comment = "Management VLAN ${var.default_comment}"
}
