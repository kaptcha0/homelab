resource "proxmox_virtual_environment_pool" "containers" {
  comment = "managed by terraform"
  pool_id = "containers"
}

resource "proxmox_virtual_environment_pool" "vms" {
  comment = "managed by terraform"
  pool_id = "vms"
}
