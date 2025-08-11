locals {
  k3s_server_ips = {
    for vm in proxmox_virtual_environment_vm.k3s_server :
    vm.name => flatten([for ip in flatten(vm.ipv4_addresses) : ip if ip != "127.0.0.1"])
  }
  k3s_agent_ips = {
    for vm in proxmox_virtual_environment_vm.k3s_agent :
    vm.name => flatten([for ip in flatten(vm.ipv4_addresses) : ip if ip != "127.0.0.1"])
  }
}

locals {
    all_ips = merge(local.k3s_server_ips, local.k3s_agent_ips)
}

