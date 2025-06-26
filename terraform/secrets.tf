data "sops_file" "pm_api" {
  source_file = "../secrets/terraform.enc.yaml"
}
