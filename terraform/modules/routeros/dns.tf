resource "routeros_ip_dns" "dns_server" {
  for_each              = local.all_vlans
  allow_remote_requests = true
  servers               = each.value.dns_servers
}

resource "routeros_ip_dns_record" "router" {
  for_each = local.all_vlans

  name    = "router.${each.value.domain}"
  address = each.value.gateway
  type    = "A"
  comment = "Router IP for ${each.value.comment} ${var.default_comment}"

  depends_on = [routeros_ip_dns.dns_server]
}

resource "routeros_ip_dns_record" "static_domains" {
  for_each = local.dhcp_leases

  name    = "${each.value.name}.${local.all_vlans[each.value.vlan].domain}"
  address = each.key
  type    = "A"
  comment = "Static lease for ${each.value.name} in VLAN ${each.value.vlan} ${var.default_comment}"

  depends_on = [routeros_ip_dns.dns_server]
}