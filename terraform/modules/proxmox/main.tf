terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.2"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.pm_api_url

  api_token = local.pm_api_token
  insecure  = true

  ssh {
    agent    = true
    username = var.pm_user
  }
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
  pm_api_token = "${data.sops_file.pm_api.data["pm_api_token_id"]}=${data.sops_file.pm_api.data["pm_api_token_secret"]}"
}
