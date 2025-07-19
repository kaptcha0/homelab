terraform {
  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "1.2.0"
    }
  }
}

locals {
  default_comment = "(Managed by Terraform)"
}

module "proxmox" {
  source = "./modules/proxmox/"

  pm_api_token = "${data.sops_file.secrets.data["pm_api_token_id"]}=${data.sops_file.secrets.data["pm_api_token_secret"]}"
  default_comment = local.default_comment
}

module "mikrotik" {
  source            = "./modules/mikrotik/"
  mikrotik_password = data.sops_file.secrets.data["routeros_api_password"]
  default_comment   = local.default_comment
}
