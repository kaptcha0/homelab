{ config, lib, ... }:
{
  config = lib.mkIf config.vms.k3s.enable {
    output.k3s = {
      value = {
        servers = lib.tfRef "proxmox_virtual_environment_vm.k3s_server";
        agents = lib.tfRef "proxmox_virtual_environment_vm.k3s_agent";
      };
    };
  };
}
