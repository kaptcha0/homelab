terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
      version = "~> 1.86.0"
    }
  }
}

module "firewall_rules" {
  source = "../firewall_rules"

  default_comment   = var.default_comment

  interfaces = local.interfaces
}

module "shared" {
  source = "../shared"
}