{ lib, config, ... }:
{
  options.vms.k3s = {
    enable = lib.mkEnableOption "enable k3s vms on proxmox";

    config.defaults = {
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
    };

    config.proxmox = {
      node_name = lib.mkOption {
        type = lib.types.str;
        description = "the node to provision things on";
      };

      datastore_id = lib.mkOption {
        type = lib.types.str;
        description = "the datastore to put the vm disks on";
      };
    };

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
    };
  };

  config =
    let
      createK3sVm =
        {
          name,
          startup_order,
          tags,
          vm_config,
        }:
        with config.vms;
        {
            inherit (k3s.config.proxmox) node_name;


            name = "${name}-\${count.index}";
            count = vm_config.count;

            tags = [
              "k3s"
              "terraform"
              "nix"
            ]
            ++ tags;

            timeout_shutdown_vm = k3s.config.defaults.timeout;
            timeout_start_vm = k3s.config.defaults.timeout;
            timeout_stop_vm = k3s.config.defaults.timeout;
            timeout_clone = k3s.config.defaults.timeout;
            timeout_create = k3s.config.defaults.timeout;
            timeout_migrate = k3s.config.defaults.timeout;
            timeout_reboot = k3s.config.defaults.timeout;

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
              datastore_id = k3s.config.proxmox.datastore_id;
              import_from = lib.tfRef "proxmox_virtual_environment_download_file.ubuntu-jammy.id";
            };

            network_device.bridge = k3s.config.defaults.lan_name;

            initialization = {
              ip_config.ipv4.address = "dhcp";

              user_account = {
                username = k3s.config.defaults.username;
                keys = k3s.config.defaults.ssh_public_keys;
              };
            };
        };
    in
    with config.vms;
    lib.mkIf k3s.enable {
      resource."proxmox_virtual_environment_vm" = {
        k3s_server = createK3sVm {
          name = "k3s-server";
          startup_order = 2;
          tags = [ "k3s-server" ];
          vm_config = k3s.config.server;
        };

        k3s_agent = createK3sVm {
          name = "k3s-agent";
          startup_order = 3;
          tags = [ "k3s-agent" ];
          vm_config = k3s.config.agent;
        };
      };
    };
}
