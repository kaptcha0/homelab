{ config, lib, ... }:
let
  cfg = config.infra;
in
{
  options.infra = {
    truenas = {
      enable = lib.mkEnableOption "enable truenas";

      config = {
        cores = lib.mkOption {
          type = lib.types.int;
          description = "CPU core count";
        };

        memory = lib.mkOption {
          type = lib.types.int;
          description = "RAM size in megabytes";
        };

        disks = {
          boot.size = lib.mkOption {
            type = lib.types.int;
            description = "the boot disk size";
          };

          data.count = lib.mkOption {
            type = lib.types.int;
            description = "the data disk count";
          };

          data.size = lib.mkOption {
            type = lib.types.int;
            description = "the data disk size";
          };
        };
      };
    };

    config = {
      defaults = {
        lan_name = lib.mkOption {
          type = lib.types.str;
          description = "the name of the LAN network interface";
        };

        timeout = lib.mkOption {
          type = lib.types.ints.positive;
          description = "the default timeouts for the vms";
        };

        username = lib.mkOption {
          type = lib.types.str;
          description = "the default username for the vm";
        };

        ssh_public_keys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "the ssh public keys";
        };

        vga = lib.mkOption {
          type = lib.types.attrs;
          description = "the vga configuration";
        };
      };

      proxmox = {
        node_name = lib.mkOption {
          type = lib.types.str;
          description = "the node to provision things on";
        };

        datastore_id = lib.mkOption {
          type = lib.types.str;
          description = "the datastore to put the vm disks on";
        };
      };
    };
  };

  config = lib.mkIf cfg.truenas.enable {
    resource."random_string".disk1_serial = {
      length = 20;
      special = false;
    };

    resource."random_string".disk2_serial = {
      length = 20;
      special = false;
    };

    resource."proxmox_virtual_environment_vm".truenas =
      let
        self = config.resource."proxmox_virtual_environment_vm".truenas;
      in
      {
        inherit (cfg.config.proxmox) node_name;
        inherit (cfg.config.defaults) vga;

        name = "truenas";
        agent.enabled = true;

        tags = [
          "storage"
          "terraform"
        ];

        timeout_shutdown_vm = cfg.config.defaults.timeout;
        timeout_start_vm = cfg.config.defaults.timeout;
        timeout_stop_vm = cfg.config.defaults.timeout;
        timeout_clone = cfg.config.defaults.timeout;
        timeout_create = cfg.config.defaults.timeout;
        timeout_migrate = cfg.config.defaults.timeout;
        timeout_reboot = cfg.config.defaults.timeout;

        hook_script_file_id = lib.tfRef "proxmox_virtual_environment_file.truenas_hook.id";

        startup = {
          order = 1;
          up_delay = 5 * 60;
          down_delay = 2 * 60;
        };

        cpu = {
          cores = cfg.truenas.config.cores;
          type = "x86-64-v2-AES";
        };

        memory = {
          dedicated = cfg.truenas.config.memory;
          floating = cfg.truenas.config.memory;
        };

        network_device.bridge = cfg.config.defaults.lan_name;
        serial_device = { };

        boot_order = [
          (builtins.elemAt self.disk 0).interface
          self.cdrom.interface
        ];

        cdrom = {
          file_id = lib.tfRef "proxmox_virtual_environment_download_file.truenas.id";
          interface = "ide0";
        };

        disk = [
          {
            interface = "scsi0";
            size = cfg.truenas.config.disks.boot.size;
            ssd = true;
          }
          {
            interface = "scsi1";
            size = cfg.truenas.config.disks.data.size;
            ssd = true;
            serial = lib.tfRef "random_string.disk1_serial.id";
          }
          {
            interface = "scsi2";
            size = cfg.truenas.config.disks.data.size;
            ssd = true;
            serial = lib.tfRef "random_string.disk2_serial.id";
          }
        ];
      };
  };
}
