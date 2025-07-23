locals {
  mikrotik_host_url = "https://10.67.0.1"
  mikrotik_user     = "tf_admin"
  mikrotik_password = var.mikrotik_password

  interfaces = {
    wan        = "ether1"
    lan        = "ether2"
    lan_bridge = "lan-bridge"
  }

  network_config = {
    gateway = "10.67.0.1"
    subnet  = "10.67.0.0/24"
  }

  dhcp_config = {
    dhcp_range  = ["10.67.0.10-10.67.0.100"]
    dns_servers = ["1.1.1.1", "8.8.8.8", "10.63.0.1"]
    domain      = "home"
  }
}
