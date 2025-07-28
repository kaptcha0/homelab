locals {
  server_ips = {
    v4 = flatten([for vm in proxmox_virtual_environment_vm.k3s_server : vm.ipv4_addresses])
    v6 = flatten([for vm in proxmox_virtual_environment_vm.k3s_server : vm.ipv6_addresses])
  }

  agent_ips = {
    v4 = flatten([for vm in proxmox_virtual_environment_vm.k3s_agent : vm.ipv4_addresses])
    v6 = flatten([for vm in proxmox_virtual_environment_vm.k3s_agent : vm.ipv6_addresses])
  }


  pm_user    = "terraform"
  pm_api_url = "https://10.67.0.3:8006/api2/json"
  pm_api_token = var.pm_api_token
  pm_node    = "pve"
  pm_bridge  = "vmbr0"

  vm_template_id = 1000
  vm_storage     = "local-lvm"
  vm_bridge      = "vmbr1"
  vm_user        = "terraform"
  vm_timeout     = 60 * 60

  k3s_server_count     = 1
  k3s_server_cores     = 1
  k3s_server_memory    = 2048
  k3s_server_disk_size = 8

  k3s_agent_count     = 2
  k3s_agent_cores     = 1
  k3s_agent_memory    = 2048
  k3s_agent_disk_size = 32

  ssh_public_key = "~/.ssh/id_ed25519.pub"

}
