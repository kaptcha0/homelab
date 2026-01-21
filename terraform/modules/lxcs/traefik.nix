{ config, lib, ... }:
let
  cfg = config.lxcs;
in
{
  options.lxcs.cts.traefik.enable = lib.mkEnableOption "enable traefik container";

  config.resource."proxmox_virtual_environment_container".traefik =
    lib.mkIf cfg.cts.traefik.enable
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
          "proxy"
        ];

        startup.order = 2;

        unprivileged = true;
        features = {
          nesting = true;
        };

        initialization = {
          hostname = "traefik";
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

        cpu.cores = 1;

        memory = {
          dedicated = 1 * 1024;
          swap = 1 * 1024;
        };
      };
}
