output "pm_api_token" {
  value     = local.pm_api_token
  sensitive = true
}

output "k3s_server_ips" {
  value = concat(local.server_ips.v4, local.server_ips.v6)
}

output "k3s_agent_ips" {
  value = concat(local.agent_ips.v4, local.agent_ips.v6)
}

