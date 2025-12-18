{ lib, ... }:
{
  terraform.required_providers = {
    proxmox = {
      source = "bpg/proxmox";
      version = "~> 0.81.0";
    };

    sops = {
      source = "carlpett/sops";
      version = "~> 1.2.1";
    };
  };

  provider = {
    proxmox = {
      endpoint = lib.tfRef "var.proxmox_api_url";
      api_token =
        (lib.tfRef "data.sops_file.secrets.data[\"pm_api_token_id\"]")
        + "="
        + (lib.tfRef "data.sops_file.secrets.data[\"pm_api_token_secret\"]");
      insecure = true;
    };
  };
}
