resource "routeros_interface_bridge" "lan_bridge" {
  name           = "lan-bridge"
  admin_mac      = "BC:24:11:5F:0F:E2"
  vlan_filtering = true
  comment        = var.default_comment
}

resource "routeros_interface_bridge_port" "bridge_ports" {
  bridge    = routeros_interface_bridge.lan_bridge.name
  interface = local.interfaces.lan
  comment   = var.default_comment
  pvid      = local.vlans.untagged[0].id
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
  interface = routeros_interface_bridge.lan_bridge.name
  list      = routeros_interface_list.lan.name
}