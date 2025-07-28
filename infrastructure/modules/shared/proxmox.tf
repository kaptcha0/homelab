output "proxmox_config" {
  value = {
    pm_node = "pve"
    vm_storage = "local-lvm"
    vm_bridge = "vmbr1"
    pm_bridge = "vmbr0"
  }
}