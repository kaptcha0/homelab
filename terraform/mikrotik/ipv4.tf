resource "routeros_ip_address" "lan" {
  address   = "10.67.0.1/24"
  interface = routeros_interface_bridge.bridge.name
  network   = "10.67.0.0"
  comment   = var.default_comment
}

resource "routeros_ip_dhcp_client" "wan" {
  interface = "ether1"
  comment   = var.default_comment
}
