resource "routeros_ip_address" "ips" {
  for_each = local.all_vlans

  interface = routeros_interface_vlan.vlans[each.key].name
  address   = "${each.value.gateway}/${each.value.cidr.mask}"
  network   = each.value.cidr.network
  comment   = var.default_comment
}

resource "routeros_ip_dhcp_client" "wan" {
  interface = "ether1"
  comment   = var.default_comment
}
