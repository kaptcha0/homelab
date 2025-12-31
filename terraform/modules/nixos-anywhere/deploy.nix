{ lib, config, ... }:
let
  all_servers = "resource.proxmox_virtual_environment_vm.k3s_server";
  all_agents = "resource.proxmox_virtual_environment_vm.k3s_agent";

  master_ip = lib.tfRef "${all_servers}[0].ipv4_addresses[1][0]";
  servers = "slice(${all_servers}, 1, length(${all_servers}))";

  extra_files_script = "${./copy-files.sh}";

  cfg = config.nixos-anywhere;
  install_user = cfg.install-user;

  build_on_remote = false;
in
{
  options = {
    nixos-anywhere = {
      enable = lib.mkEnableOption "enable nixos-anywhere";

      install-user = lib.mkOption {
        type = lib.types.str;
        description = "the username to connect with";
      };
    };
  };

  config.module = {
    deploy-master = lib.mkIf cfg.enable {
      inherit extra_files_script install_user build_on_remote;
      source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one";

      nixos_system_attr = ".#nixosConfigurations.k3s-server-master.config.system.build.toplevel";
      nixos_partitioner_attr = ".#nixosConfigurations.k3s-server-master.config.system.build.diskoScript";

      target_host = master_ip;
      # when instance id changes, it will trigger a reinstall
      instance_id = master_ip;

      special_args.terraform = {
        masterIp = master_ip;
        hostname = lib.tfRef "${all_servers}[0].name";
        ipv4 = lib.tfRef "${all_servers}[0].initialization[0].ip_config[0].ipv4[0].address";
        gateway = lib.tfRef "${all_servers}[0].initialization[0].ip_config[0].ipv4[0].gateway";

        domain = lib.tfRef "${all_servers}[0].initialization[0].dns[0].domain";
        dns_servers = lib.tfRef "${all_servers}[0].initialization[0].dns[0].servers";
      };
    };

    deploy-servers = {
      inherit extra_files_script install_user build_on_remote;

      for_each = lib.tfRef "{ for vm in ${servers} : vm.name => vm }";

      source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one";

      nixos_system_attr = ".#nixosConfigurations.k3s-server.config.system.build.toplevel";
      nixos_partitioner_attr = ".#nixosConfigurations.k3s-server.config.system.build.diskoScript";

      target_host = lib.tfRef "each.value.ipv4_addresses[1][0]";
      # when instance id changes, it will trigger a reinstall
      instance_id = lib.tfRef "each.value.ipv4_addresses[1][0]";

      special_args.terraform = {
        masterIp = master_ip;
        hostname = lib.tfRef "each.key";
        ipv4 = lib.tfRef "each.value.initialization[0].ip_config[0].ipv4[0].address";
        gateway = lib.tfRef "each.value.initialization[0].ip_config[0].ipv4[0].gateway";

        domain = lib.tfRef "each.value.initialization[0].dns[0].domain";
        dns_servers = lib.tfRef "each.value.initialization[0].dns[0].servers";
      };

      depends_on = [
        "module.deploy-master"
      ];
    };

    deploy-agents = {
      inherit extra_files_script install_user build_on_remote;

      for_each = lib.tfRef "{ for vm in ${all_agents} : vm.name => vm }";

      source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one";

      nixos_system_attr = ".#nixosConfigurations.k3s-agent.config.system.build.toplevel";
      nixos_partitioner_attr = ".#nixosConfigurations.k3s-agent.config.system.build.diskoScript";

      target_host = lib.tfRef "each.value.ipv4_addresses[1][0]";
      # when instance id changes, it will trigger a reinstall
      instance_id = lib.tfRef "each.value.ipv4_addresses[1][0]";

      special_args.terraform = {
        masterIp = master_ip;
        hostname = lib.tfRef "each.key";
        ipv4 = lib.tfRef "each.value.initialization[0].ip_config[0].ipv4[0].address";
        gateway = lib.tfRef "each.value.initialization[0].ip_config[0].ipv4[0].gateway";

        domain = lib.tfRef "each.value.initialization[0].dns[0].domain";
        dns_servers = lib.tfRef "each.value.initialization[0].dns[0].servers";
      };

      depends_on = [
        "module.deploy-master"
      ];
    };
  };
}
