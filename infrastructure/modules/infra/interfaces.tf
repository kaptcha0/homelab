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

resource "proxmox_virtual_environment_network_linux_bridge" "mgmt" {
  node_name = local.pm_node
  name      = "vmbr2"
  comment   = "WIFI Management ${var.default_comment}"

  address = "10.99.0.1/24"

  ports = [ "wlp3s0" ]
}
