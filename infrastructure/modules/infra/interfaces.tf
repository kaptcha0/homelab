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

  address = "10.67.0.167/24"
  gateway = "10.67.0.2"

  vlan_aware = true

  ports = [ "enx00051b2a4e43" ]
}

resource "proxmox_virtual_environment_network_linux_bridge" "mgmt" {
  node_name = local.pm_node
  name      = "vmbr2"

  vlan_aware = true

  comment = "Management Interface ${var.default_comment}"
}

resource "proxmox_virtual_environment_network_linux_vlan" "mgmt_vlan" {
  node_name = local.pm_node
  name      = "${proxmox_virtual_environment_network_linux_bridge.mgmt.name}.${module.shared.management_vlan.id}"

  comment = "Management VLAN ${var.default_comment}"
}