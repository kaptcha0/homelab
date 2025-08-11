resource "routeros_interface_bridge" "lan_bridge" {
  name           = local.interfaces.lan_bridge
  admin_mac      = "BC:24:11:5F:0F:E2"
  vlan_filtering = true
  comment        = var.default_comment
}

resource "routeros_interface_bridge_port" "bridge_ports" {
  for_each = {
    "ether2" = { comment = var.default_comment, pvid = local.vlans.autotagged[1].id }
    "ether3" = { comment = var.default_comment, pvid = local.vlans.autotagged[99].id }
  }
  bridge    = routeros_interface_bridge.lan_bridge.name
  interface = each.key
  comment   = each.value.comment
  pvid      = each.value.pvid

  depends_on = [routeros_interface_vlan.vlans]
}

resource "routeros_interface_list" "lan" {
  name = "LAN"
}

resource "routeros_interface_list" "wan" {
  name = "WAN"
}

resource "routeros_interface_list_member" "wan" {
  interface = local.interfaces.wan
  list      = routeros_interface_list.wan.name
}

resource "routeros_interface_list_member" "lan_bridge" {
  for_each  = routeros_interface_bridge_port.bridge_ports
  interface = each.value.interface
  list      = routeros_interface_list.lan.name
}