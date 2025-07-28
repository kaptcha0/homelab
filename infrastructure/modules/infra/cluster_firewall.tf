resource "proxmox_virtual_environment_cluster_firewall" "example" {
  enabled = false

  ebtables      = true
  input_policy  = "DROP"
  output_policy = "ACCEPT"
  log_ratelimit {
    enabled = false
    burst   = 10
    rate    = "5/second"
  }
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "isolation" {
  name    = "isolation"
  comment = var.default_comment

  rules {
    type    = "in"
    action  = "ACCEPT"
    comment = "Allow all access to the cluster"
    iface   = proxmox_virtual_environment_linux_bridge.mgmt.name
    source = "10.99.0.0/24"
  }
}

resource "proxmox_virtual_environment_firewall_rules" "input" {
  rules {
    security_group = proxmox_virtual_environment_cluster_firewall_security_group.isolation.name
  }

  rules {
    type    = "in"
    action  = "DROP"
    comment = "Drop everything on LAN"
    iface   = proxmox_virtual_environment_linux_bridge.lan.name
  }

  rules {
    type    = "in"
    action  = "DROP"
    comment = "Drop everything on WAN"
    iface   = proxmox_virtual_environment_linux_bridge.wan.name
  }
}