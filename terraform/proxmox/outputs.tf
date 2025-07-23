output "pm_api_token" {
  value     = local.pm_api_token
  sensitive = true
}

output "k3s_server_ips" {
  value = local.server_ips.v4
}

output "k3s_agent_ips" {
  value = local.agent_ips.v4
}

output "tailscale_container_ip" {
  value = proxmox_virtual_environment_container.tailscale_container
}

output "tailscale_container_password" {
  value     = random_password.tailscale_container_password.result
  sensitive = true
}

output "tailscale_container_private_key" {
  value     = tls_private_key.tailscale_container_key.private_key_pem
  sensitive = true
}

output "tailscale_container_public_key" {
  value = tls_private_key.tailscale_container_key.public_key_openssh
}