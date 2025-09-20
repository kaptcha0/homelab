output "ip_addresses" {
  value = {
    k3s_server_ips = local.k3s_server_ips
    k3s_agent_ips  = local.k3s_agent_ips
    all_ips        = local.all_ips
  }
}
