data "sops_file" "pm_api" {
  source_file = "../secrets/proxmox.enc.yaml"
}

locals {
  pm_api_token = "${data.sops_file.pm_api.data["terraform.pm_api_token_id"]}=${data.sops_file.pm_api.data["terraform.pm_api_token_secret"]}"
}

output "pm_api_token" {
  value     = local.pm_api_token
  sensitive = true
}
