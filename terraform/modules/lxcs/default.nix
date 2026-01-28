{ lib, ... }:
{
  imports = [
    ./downloads.nix
    ./files.nix
    ./netbird.nix
    ./vaultwarden.nix
    ./traefik.nix
  ];
  options.lxcs = {
    enable = lib.mkEnableOption "enable lxcs";
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
          description = "the datastore to put the container disks on";
        };

        shared_storage = lib.mkOption {
          type = lib.types.str;
          description = "the datastore to put extra container images on";
        };
      };
    };
  };
}
