{ config, lib, ... }:
let
  cfg = config.lxcs;
in
{
  options.lxcs.cts.file-storage.enable = lib.mkEnableOption "enable filestorage container";

  config.resource."proxmox_virtual_environment_container".file-storage =
    lib.mkIf cfg.cts.file-storage.enable
      {
        inherit (cfg.config.proxmox) node_name;

        unprivileged = true;
        features = {
          nesting = true;
        };

        initialization = {
          hostname = "files";
          ip_config.ipv4.address = "dhcp";
        };

        network_interface.name = "veth0";

        operating_system = {
          template_file_id = lib.tfRef "proxmox_virtual_environment_file.nixos-lxc-template.id";
          type = "nixos";
        };

        disk = [
          {
            inherit (cfg.config.proxmox) datastore_id;
            size = 16;
          }
        ];

        mount_point = [
          {
            volume = cfg.config.proxmox.shared_storage;
            size = "200G";
            path = "/mnt/data";
          }
        ];

        cpu.cores = 1;

        memory = {
          dedicated = 2 * 1024;
          swap = 1024;
        };
      };
}
