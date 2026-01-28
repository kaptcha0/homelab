{ config, lib, ... }:
let
  cfg = config.lxcs;
in
{
  options.lxcs.cts.lgtm.enable = lib.mkEnableOption "enable lgtm container";

  config.resource."proxmox_virtual_environment_container".lgtm = lib.mkIf cfg.cts.lgtm.enable {
    inherit (cfg.config.proxmox) node_name;

    timeout_create = cfg.config.defaults.timeout;
    timeout_clone = cfg.config.defaults.timeout;
    timeout_delete = cfg.config.defaults.timeout;
    timeout_update = cfg.config.defaults.timeout;

    depends_on = [
      "proxmox_virtual_environment_vm.truenas"
    ];

    tags = [
      "metrics"
    ];

    startup.order = 2;

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
      hostname = "lgtm";
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
        size = 128;
      }
    ];

    cpu.cores = 2;

    memory = {
      dedicated = 2 * 1024;
      swap = 1 * 1024;
    };
  };
}
