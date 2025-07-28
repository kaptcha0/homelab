terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
      version = "1.85.3"
    }
  }
}

provider "routeros" {
  hosturl = local.mikrotik_host_url
  username = local.mikrotik_user
  password = local.mikrotik_password
  insecure = true
}

module "firewall_rules" {
  source = "./firewall_rules"

  mikrotik_host_url = local.mikrotik_host_url
  mikrotik_user     = local.mikrotik_user
  mikrotik_password = local.mikrotik_password

  default_comment   = var.default_comment

  interfaces = local.interfaces
}

module "shared" {
  source = "../shared"
}