{ config, lib, ... }:
let
  cfg = config.lxcs;
in
{
  options.lxcs.cts.netbird.enable = lib.mkEnableOption "enable netbird container";

  config.resource."proxmox_virtual_environment_container".netbird = lib.mkIf cfg.cts.netbird.enable {
    inherit (cfg.config.proxmox) node_name;

    timeout_create = cfg.config.defaults.timeout;
    timeout_clone = cfg.config.defaults.timeout;
    timeout_delete = cfg.config.defaults.timeout;
    timeout_update = cfg.config.defaults.timeout;

    depends_on = [
      "proxmox_virtual_environment_vm.truenas"
    ];

    tags = [
      "networking"
      "remote-access"
    ];

    unprivileged = true;
    features = {
      nesting = true;
      keyctl = true;
    };

    initialization = {
      hostname = "netbird";
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

    device_passthrough = [
      {
        path = "/dev/net/tun";
        deny_write = false;
        mode = "0666";
      }
    ];

    cpu.cores = 1;

    memory = {
      dedicated = 1024;
      swap = 1024;
    };
  };
}
