terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0.81.0"
    }
  }
}

module "shared" {
  source = "../shared/"
}

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
