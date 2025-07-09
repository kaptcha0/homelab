resource "proxmox_virtual_environment_network_linux_bridge" "vm_network" {
  node_name = var.pm_node
  name      = var.vm_bridge

  comment = "managed by terraform"

  address = "10.10.10.1/24"
  ports   = []
}

resource "proxmox_virtual_environment_firewall_rules" "block_lan_access" {
  node_name = var.pm_node

  rule {
    type   = "out"
    action = "REJECT"
    dest   = "192.168.1.0/24"
    log    = "info"
  }

  rule {
    type   = "in"
    action = "REJECT"
    source = "192.168.1.0/24"
    log    = "info"
  }

  rule {
    security_group = "tf_sec_group"
    comment        = "(terraform): block lan access on vmbr1"
    iface          = "vmbr1"
  }
}

