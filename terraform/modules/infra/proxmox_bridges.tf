resource "proxmox_virtual_environment_network_linux_bridge" "uplink" {
  node_name = module.shared.proxmox_config.primary_node
  name = module.shared.proxmox_config.bridges.uplink.name

  address = module.shared.proxmox_config.bridges.uplink.address
  gateway = module.shared.proxmox_config.bridges.uplink.gateway

  ports = module.shared.proxmox_config.bridges.uplink.ports
}

resource "proxmox_virtual_environment_network_linux_bridge" "lan" {
  node_name = module.shared.proxmox_config.primary_node
  name = module.shared.proxmox_config.bridges.lan.name

  address = module.shared.proxmox_config.bridges.lan.address

  ports = module.shared.proxmox_config.bridges.lan.ports
}

resource "proxmox_virtual_environment_network_linux_bridge" "mgmt" {
  node_name = module.shared.proxmox_config.primary_node
  name = module.shared.proxmox_config.bridges.mgmt.name

  address = module.shared.proxmox_config.bridges.mgmt.address

  ports = module.shared.proxmox_config.bridges.mgmt.ports
}
