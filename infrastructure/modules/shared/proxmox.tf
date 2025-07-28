output "proxmox_config" {
  value = {
    pm_node    = "pve"
    pm_storage = "local"
    vm_storage = "local-lvm"
  }
}