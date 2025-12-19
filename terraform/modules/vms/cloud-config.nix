{ config, lib, ... }:
let
  cfg = config.vms;
in
{
  config = lib.mkIf cfg.k3s.enable {
    resource."proxmox_virtual_environment_file".cloud_config = {
      content_type = "snippets";
      datastore_id = "local";
      node_name = "pve";

      source_raw = {
        file_name = "default.cloud-config.yaml";
        data = ''
          #cloud-config
          packages:
            - qemu-guest-agent
        '';
      };

    };
  };
}
