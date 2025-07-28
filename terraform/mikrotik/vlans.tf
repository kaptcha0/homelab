resource "routeros_interface_bridge_vlan" "lan_bridge_tagged" {
  bridge = local.interfaces.lan_bridge
  vlan_ids = [ for vlan in local.vlans.tagged : vlan.id ]
  tagged = [ local.interfaces.lan ]

  comment = "Tagged VLANs on LAN bridge ${var.default_comment}"
}