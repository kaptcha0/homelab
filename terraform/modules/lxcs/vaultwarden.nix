{ config, lib, ... }:
let
  cfg = config.lxcs;
in
{
  options.lxcs.cts.vaultwarden.enable = lib.mkEnableOption "enable vaultwarden container";

  config.resource."proxmox_virtual_environment_container".vaultwarden =
    lib.mkIf cfg.cts.vaultwarden.enable
      {
        inherit (cfg.config.proxmox) node_name;

        timeout_create = cfg.config.defaults.timeout;
        timeout_clone = cfg.config.defaults.timeout;
        timeout_delete = cfg.config.defaults.timeout;
        timeout_update = cfg.config.defaults.timeout;

        depends_on = [
          "proxmox_virtual_environment_vm.truenas"
        ];

        tags = [
          "public"
          "storage"
        ];

        startup.order = 3;

        unprivileged = true;
        features = {
          nesting = true;
        };

        lifecycle = {
          ignore_changes = [
            "operating_system[0].template_file_id"
          ];
        };

        initialization = {
          hostname = "vaultwarden";
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
            size = "64G";
            path = "/mnt/data";
          }
        ];

        cpu.cores = 2;

        memory = {
          dedicated = 1 * 1024;
          swap = 1 * 1024;
        };
      };
}
