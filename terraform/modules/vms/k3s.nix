{ lib, config, ... }:
let
  cfg = config.vms;
in
{
  options.vms = {
    k3s = {
      enable = lib.mkEnableOption "enable k3s vms on proxmox";

      config.server = {
        count = lib.mkOption {
          default = 1;
          type = lib.types.ints.positive;
          description = "how many k3s server nodes to deploy";
        };

        cores = lib.mkOption {
          default = 1;
          type = lib.types.ints.positive;
          description = "cores per k3s server node";
        };

        memory = lib.mkOption {
          default = 512;
          type = lib.types.ints.positive;
          description = "memory per k3s server node (MB)";
        };

        storage = lib.mkOption {
          default = 16;
          type = lib.types.ints.positive;
          description = "storage per k3s server node (GB)";
        };
      };

      config.agent = {
        count = lib.mkOption {
          default = 1;
          type = lib.types.ints.positive;
          description = "how many k3s agent nodes to deploy";
        };

        cores = lib.mkOption {
          default = 1;
          type = lib.types.ints.positive;
          description = "cores per k3s agent node";
        };

        memory = lib.mkOption {
          default = 512;
          type = lib.types.ints.positive;
          description = "memory per k3s agent node (MB)";
        };

        storage = lib.mkOption {
          default = 16;
          type = lib.types.ints.positive;
          description = "storage per k3s agent node (GB)";
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

  config =
    let
      createK3sVm =
        {
          name,
          startup_order,
          tags,
          starting_index,
          vm_config,
        }:
        {
          inherit (cfg.config.proxmox) node_name;
          inherit (cfg.config.defaults) vga;

          name = "${name}-\${count.index}";
          count = vm_config.count;

          tags = [
            "k3s"
            "terraform"
            "nix"
          ]
          ++ tags;

          timeout_shutdown_vm = cfg.config.defaults.timeout;
          timeout_start_vm = cfg.config.defaults.timeout;
          timeout_stop_vm = cfg.config.defaults.timeout;
          timeout_clone = cfg.config.defaults.timeout;
          timeout_create = cfg.config.defaults.timeout;
          timeout_migrate = cfg.config.defaults.timeout;
          timeout_reboot = cfg.config.defaults.timeout;

          serial_device = { };

          agent = {
            enabled = true;
            timeout = "20m";
          };

          startup = {
            order = startup_order;
            up_delay = 60;
            down_delay = 60;
          };

          cpu = {
            cores = vm_config.cores;
            type = "x86-64-v2-AES";
          };

          memory = {
            dedicated = vm_config.memory;
            floating = vm_config.memory;
          };

          disk = {
            interface = "virtio0";
            datastore_id = cfg.config.proxmox.datastore_id;
            import_from = lib.tfRef "proxmox_virtual_environment_download_file.fedora-43.id";
            size = vm_config.storage;
          };

          network_device.bridge = cfg.config.defaults.lan_name;

          initialization = {
            ip_config.ipv4 = {
              gateway = "10.67.0.1";
              address = "10.67.0.${lib.tfRef "${toString starting_index} + count.index"}/24";
            };

            dns = {
              domain = "nyumbani.home";
              servers = [
                "10.67.0.1"
                "1.1.1.1"
              ];
            };

            user_account = {
              username = cfg.config.defaults.username;
              keys = cfg.config.defaults.ssh_public_keys;
            };
          };
        };
    in
    lib.mkIf cfg.k3s.enable {
      resource."proxmox_virtual_environment_vm" = {
        k3s_server = createK3sVm {
          name = "k3s-server";
          startup_order = 2;
          tags = [ "k3s-server" ];
          starting_index = 10;
          vm_config = cfg.k3s.config.server;
        };

        k3s_agent = createK3sVm {
          name = "k3s-agent";
          startup_order = 3;
          tags = [ "k3s-agent" ];
          starting_index = 50;
          vm_config = cfg.k3s.config.agent;
        };
      };
    };
}
