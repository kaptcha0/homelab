resource "proxmox_virtual_environment_network_linux_bridge" "name" {
  node_name = var.pm_node
  name      = var.vm_bridge

  comment = "managed by terraform"

  address = "10.10.10.0/24"
  ports   = []
}
