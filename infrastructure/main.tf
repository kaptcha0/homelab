terraform {
  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.2.1"
    }
    
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.80.0"
    }

    routeros = {
      source = "terraform-routeros/routeros"
      version = "~> 1.86.0"
    }
  }
}

locals {
  default_comment = "(Managed by Terraform)"
}

module "proxmox" {
  source = "./proxmox/"

  default_comment = local.default_comment
  k3s_password = data.sops_file.secrets.data["k3s_password"]

  depends_on = [ module.routeros ]
}

module "mikrotik" {
  source            = "./mikrotik/"

  default_comment   = local.default_comment
}

module "routeros" {
  source = "./mikrotik/routeros"
  
  default_comment = local.default_comment
  depends_on = [ module.mikrotik ]
}
