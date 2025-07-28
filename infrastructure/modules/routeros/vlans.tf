resource "routeros_interface_bridge_vlan" "lan_bridge_tagged" {
  bridge = local.interfaces.lan_bridge
  vlan_ids = [ for vlan in local.vlans.tagged : vlan.id ]
  tagged = [ local.interfaces.lan, local.interfaces.lan_bridge ]

  comment = "Tagged VLANs on LAN bridge ${var.default_comment}"
}

resource "routeros_interface_bridge_vlan" "lan_bridge_untagged" {
  bridge = local.interfaces.lan_bridge
  vlan_ids = [ for vlan in local.vlans.untagged : vlan.id ]
  tagged = [ local.interfaces.lan_bridge ]
  untagged = [ local.interfaces.lan ]

  comment = "Untagged VLANs on LAN bridge ${var.default_comment}"
}

resource "routeros_interface_vlan" "vlans" {
  for_each = local.all_vlans

  name     = "vlan${each.key}"
  vlan_id  = each.key
  interface = local.interfaces.lan_bridge
  comment  = var.default_comment
}