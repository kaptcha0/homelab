locals {
  pm_node    = module.shared.proxmox_config.pm_node
  vm_storage = module.shared.proxmox_config.vm_storage
  vm_bridge  = module.shared.proxmox_config.vm_bridge
  pm_bridge  = module.shared.proxmox_config.pm_bridge
}