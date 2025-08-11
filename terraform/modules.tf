module "shared" {
  source = "./modules/shared/"
}

module "infra" {
  source = "./modules/infra/"
}

module "routeros" {
  source          = "./modules/routeros/"
  default_comment = "(managed by terraform)"
  depends_on      = [module.infra]
}

module "vms" {
  source = "./modules/vms/"

  k3s_disk_import_id = module.infra.proxmox_downloads.debian12.id

  k3s_server_count  = 1
  k3s_server_cores  = 2
  k3s_server_memory = 2048

  k3s_agent_count  = 2
  k3s_agent_cores  = 2
  k3s_agent_memory = 2048

  depends_on = [module.infra, module.routeros]
}
