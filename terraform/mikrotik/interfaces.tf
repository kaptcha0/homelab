resource "routeros_interface_bridge" "bridge" {
  name           = "lan-bridge"
  admin_mac      = "BC:24:11:5F:0F:E2"
}

resource "routeros_interface_bridge_port" "bridge_ports" {
  for_each = {
    "ether2"       = { comment = var.default_comment, pvid = "1" }
  }
  bridge    = routeros_interface_bridge.bridge.name
  interface = each.key
  comment   = "${each.value.comment} ${var.default_comment}"
  pvid      = each.value.pvid
}

resource "routeros_interface_list" "lan" {
  name = "LAN"
}

resource "routeros_interface_list_member" "lan_bridge" {
  interface = routeros_interface_bridge.bridge.name
  list      = routeros_interface_list.lan.name
}