resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0" {
  node_name = local.pm_node
  name      = "vmbr0"

  address = "10.67.0.167/24"
  gateway = "10.67.0.1"

  comment   = "${var.default_comment}"

  ports = [ "eno1" ]
}
