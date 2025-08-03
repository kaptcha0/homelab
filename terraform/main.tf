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
  }
}

provider "proxmox" {
  endpoint  = data.sops_file.pm_api.data["pm_api_url"]
  api_token = "${data.sops_file.pm_api.data["pm_api_token_id"]}=${data.sops_file.pm_api.data["pm_api_token_secret"]}"
  insecure  = true
}

module "shared" {
  source = "./modules/shared/"
}

module "infra" {
  source = "./modules/infra/"
}

module "vms" {
  source = "./modules/vms/"

  omv_iso_import_id = module.infra.proxmox_downloads.debian12.id
  k3s_disk_import_id = module.infra.proxmox_downloads.debian12.id

  k3s_server_count     = 1
  k3s_server_cores     = 2
  k3s_server_memory    = 2048
  k3s_server_disk_size = 8

  k3s_agent_count     = 2
  k3s_agent_cores     = 2
  k3s_agent_memory    = 2048
  k3s_agent_disk_size = 8

}
