
resource "routeros_ip_dhcp_server" "lan_dhcp" {
  for_each = local.all_vlans
  
  interface = local.interfaces.lan_bridge
  name = "lan_dhcp_vlan_${each.value.id}"
  address_pool = routeros_ip_pool.lan_pool[each.key].name
  lease_time = "30m"

  comment = var.default_comment
}

resource "routeros_ip_dhcp_server_network" "lan_network" {
  for_each = local.all_vlans

  address = "${each.value.cidr.network}/${each.value.cidr.mask}"
  gateway = each.value.gateway
  dns_server = each.value.dns_servers
  domain = each.value.domain

  comment = var.default_comment
}
resource "routeros_ip_pool" "lan_pool" {
  for_each = local.all_vlans

  name = "lan_pool_vlan_${each.value.id}"
  ranges = each.value.pools

  comment = var.default_comment
}

resource "routeros_ip_dhcp_server_lease" "lan_static_leases" {
  for_each = local.dhcp_leases

  address = each.key
  mac_address = each.value.mac
  comment = "${each.value.name} ${var.default_comment}"
  server = routeros_ip_dhcp_server.lan_dhcp[each.value.vlan].name

  depends_on = [routeros_ip_dhcp_server.lan_dhcp]
}