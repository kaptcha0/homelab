resource "proxmox_virtual_environment_network_linux_bridge" "bridges" {
  for_each = module.shared.proxmox_config.bridges
  
  node_name = module.shared.proxmox_config.primary_node
  name = each.value.name

  address = each.value.address
  gateway = each.value.gateway

  ports = each.value.ports
}


