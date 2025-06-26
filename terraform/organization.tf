resource "proxmox_virtual_environment_pool" "k3s_pool" {
  comment = "managed by terraform"
  pool_id = "k3s_pool"
}
