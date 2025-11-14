terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.81.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "~> 1.2.1"
    }

    routeros = {
      source  = "terraform-routeros/routeros"
      version = "~> 1.86.0"
    }
  }
}

provider "proxmox" {
  endpoint  = data.sops_file.secrets.data["pm_api_url"]
  api_token = "${data.sops_file.secrets.data["pm_api_token_id"]}=${data.sops_file.secrets.data["pm_api_token_secret"]}"
  insecure  = true
}

variable "routeros_ip" {
  type = string
}

provider "routeros" {
  hosturl  = "https://${var.routeros_ip}"
  username = data.sops_file.secrets.data["routeros_api_username"]
  password = data.sops_file.secrets.data["routeros_api_password"]
  insecure = true
}
