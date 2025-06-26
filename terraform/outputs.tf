locals {
  server_ips = {
    v4 = flatten([for vm in proxmox_virtual_environment_vm.k3s_server : vm.ipv4_addresses])
    v6 = flatten([for vm in proxmox_virtual_environment_vm.k3s_server : vm.ipv6_addresses])
  }
  agent_ips = {
    v4 = flatten([for vm in proxmox_virtual_environment_vm.k3s_agent : vm.ipv4_addresses])
    v6 = flatten([for vm in proxmox_virtual_environment_vm.k3s_agent : vm.ipv6_addresses])
  }
}

output "k3s_server_ips" {
  value = concat(local.server_ips.v4, local.server_ips.v6)
}

output "k3s_agent_ips" {
  value = concat(local.agent_ips.v4, local.agent_ips.v6)
}

