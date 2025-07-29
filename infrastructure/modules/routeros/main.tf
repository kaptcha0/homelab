terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "~> 1.86.0"
    }
  }
}

module "shared" {
  source = "../shared"
}