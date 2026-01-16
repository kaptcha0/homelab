{ config, lib, ... }:
let
  cfg = config.infra;
in
{
  resource."proxmox_virtual_environment_storage_nfs".shared_storage = lib.mkIf cfg.truenas.enable {
    id = "shared-nfs-storage";
    server = lib.tfRef "proxmox_virtual_environment_vm.truenas.ipv4_addresses[1][0]";
    export = "/mnt/general/proxmox-storage";

    content = [
      "images"
      "rootdir"
    ];
  };
}
