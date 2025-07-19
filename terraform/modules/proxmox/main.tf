terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.2"
    }
  }
}

provider "proxmox" {
  endpoint = local.pm_api_url

  api_token = local.pm_api_token
  insecure  = true

  ssh {
    agent    = true
    username = local.pm_user
  }
}