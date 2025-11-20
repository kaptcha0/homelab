{ lib, ... }: {
  terraform.required_providers = {
    proxmox = {
      source = "bpg/proxmox";
      version = "~> 0.81.0";
    };

    
    sops = {
      source  = "carlpett/sops";
      version = "~> 1.2.1";
    };

    routeros = {
      source  = "terraform-routeros/routeros";
      version = "~> 1.86.0";
    };
  };



  provider = {
    proxmox = {
      endpoint = lib.tfRef "var.proxmox_api_url";
      api_token = (lib.tfRef "data.sops_file.secrets.data[\"pm_api_token_id\"]") + "=" + (lib.tfRef "data.sops_file.secrets.data[\"pm_api_token_secret\"]");
      insecure = true;
    };

    routeros = {
      hosturl  = lib.tfRef "var.routeros_api_url";
      username = lib.tfRef "data.sops_file.secrets.data[\"routeros_api_username\"]";
      password = lib.tfRef "data.sops_file.secrets.data[\"routeros_api_password\"]";
      insecure = true;
    };
  };
}
