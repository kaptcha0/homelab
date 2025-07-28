provider "routeros" {
  hosturl  = var.mikrotik_host_url
  username = var.mikrotik_user
  password = data.sops_file.secrets.data["routeros_api_password"]
  insecure = true
}

provider "proxmox" {
  endpoint = var.pm_api_url

  api_token = "${data.sops_file.secrets.data["pm_api_token_id"]}=${data.sops_file.secrets.data["pm_api_token_secret"]}"
  insecure  = true

  ssh {
    agent    = true
    username = var.pm_api_user
  }
}