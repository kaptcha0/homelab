{ lib, ... }:
{
  terraform.required_providers = {
    proxmox = {
      source = "bpg/proxmox";
      version = "~> 0.93.0";
    };

    sops = {
      source = "carlpett/sops";
      version = "~> 1.3.0";
    };
  };

  provider = {
    proxmox = {
      endpoint = lib.tfRef "var.proxmox_api_url";

      username = lib.tfRef "data.sops_file.secrets.data[\"pm_username\"]";
      password = lib.tfRef "data.sops_file.secrets.data[\"pm_password\"]";

      insecure = true;

      ssh = {
        agent = true;
        username = "root";
      };
    };
  };
}
