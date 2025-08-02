locals {
  k3s_server_ips = flatten([
    for vm in proxmox_virtual_environment_vm.k3s_agent :
      [ for ip in vm.ipv4_addresses : ip if ip != "127.0.0.1" ]
  ])
  k3s_agent_ips = flatten([
    for vm in proxmox_virtual_environment_vm.k3s_agent :
      [ for ip in vm.ipv4_addresses : ip if ip != "127.0.0.1" ]
  ])
  omv_ips = flatten([
    for vm in proxmox_virtual_environment_vm.omv.ipv4_addresses :
    vm
    if vm != "127.0.0.1"
  ])
}

output "ip_addresses" {
  value = {
    k3s_server_ips  = local.k3s_server_ips
    k3s_agent_ips   = local.k3s_agent_ips
    omv_ips         = local.omv_ips
    all_ips         = concat(local.k3s_server_ips, local.k3s_agent_ips, local.omv_ips)
  }
}