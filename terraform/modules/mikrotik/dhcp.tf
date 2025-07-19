resource "routeros_ip_dhcp_server" "lan_dhcp" {
  interface = local.interfaces.lan_bridge
  name = "lan_dhcp"
  address_pool = routeros_ip_pool.lan_pool.name
  lease_time = "30m"

  comment = var.default_comment
}

resource "routeros_ip_dhcp_server_network" "lan_network" {
  address = local.network_config.subnet
  gateway = local.network_config.gateway
  dns_server = local.dhcp_config.dns_servers
  domain = local.dhcp_config.domain

  comment = var.default_comment
}

resource "routeros_ip_pool" "lan_pool" {
  name = "lan_pool"
  ranges = local.dhcp_config.dhcp_range

  comment = var.default_comment
}

resource "routeros_ip_dns" "dns-server" {
  allow_remote_requests = true
  servers = local.dhcp_config.dns_servers
}