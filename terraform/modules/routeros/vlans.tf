resource "routeros_interface_bridge_vlan" "lan_bridge_autotagged_vlans" {
  for_each = local.vlans.autotagged

  bridge   = routeros_interface_bridge.lan_bridge.name
  vlan_ids = [each.value.id]
  tagged   = [routeros_interface_bridge.lan_bridge.name]
  untagged = [each.value.untagged_interface]

  comment = "Autotagged VLAN on LAN bridge ${var.default_comment}"

  depends_on = [
    routeros_interface_vlan.vlans
  ]
}

resource "routeros_interface_bridge_vlan" "lan_bridge_tagged" {
  for_each = local.vlans.tagged
  bridge   = routeros_interface_bridge.lan_bridge.name
  vlan_ids = [each.value.id]
  tagged   = [routeros_interface_bridge.lan_bridge.name, local.interfaces.lan]

  comment = "Tagged VLAN on LAN bridge ${var.default_comment}"

  depends_on = [routeros_interface_vlan.vlans]
}

resource "routeros_interface_vlan" "vlans" {
  for_each = local.all_vlans

  name      = "vlan${each.key}"
  vlan_id   = each.key
  interface = routeros_interface_bridge.lan_bridge.name
  comment   = var.default_comment
}