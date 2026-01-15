{
  config,
  lib,
  pkgs,
  modulesPath,
  terraform,
  ...
}@args:

let
  publicKeyFile = builtins.fetchurl {
    url = "https://github.com/kaptcha0.keys";
    sha256 = "0j8njsssxjj3yb4dzydbf8z2hmpfcjjb2l5warjm8c5cngbqxi14";
  };
  publicKeys = lib.strings.removeSuffix "\n" (builtins.readFile publicKeyFile);
  ipv4 = lib.strings.splitString "/" terraform.ipv4;
  k3sEnvFile = pkgs.writeText "k3s.env" ''
    GOMEMLIMIT=800MiB
  '';
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  boot = {
    supportedFilesystems = [ "nfs" ];
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    kernel.sysctl = {
      "vm.swappiness" = 60;
      "vm.page-cluster" = 0;
      "vm.vfs_cache_pressure" = 50;
    };
    kernelModules = [
      "nfs"
      "br_netfilter"
      "ip_conntrack"
      "overlay" # May be needed for containerd
      "virtio_balloon"
    ];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
      priority = 100;
    }
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 60;
    priority = 200;
  };

  services.openssh.enable = true;

  environment.systemPackages =
    with pkgs;
    map lib.lowPrio [
      curl
      gitMinimal
      nfs-utils
      helix
      btop
    ];

  environment.sessionVariables.EDITOR = pkgs.helix;

  services.openiscsi = {
    enable = true;
    name = "iqn.2025-12.home.nyumbani:${terraform.hostname}";
  };

  users.users.root.openssh.authorizedKeys.keys =
    (lib.strings.splitString "\n" publicKeys) ++ (args.extraPublicKeys or [ ]); # this is used for unit-testing this module and can be removed if not needed

  services.qemuGuest.enable = true;

  sops.defaultSopsFile = ./nixos.secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/var/lib/secrets/keys.txt";

  sops.secrets.server_token = { };

  services.k3s = {
    enable = true;
    tokenFile = config.sops.secrets.server_token.path;
    environmentFile = toString k3sEnvFile;
    extraKubeletConfig = {
      failSwapOn = false;
      memorySwap.swapBehavior = "LimitedSwap";
    };
  };

  networking = {
    hostName = terraform.hostname;
    useDHCP = false;
    domain = terraform.domain;
    search = [
      terraform.domain
      "local"
    ];
    nameservers = terraform.dns_servers;
    enableIPv6 = false;

    firewall = {
      enable = false;
      allowPing = true;

      allowedUDPPorts = [
        8472 # cilium VXLAN overlay
        51871 # cilium Wireguard tunnel endpoint
      ];

      allowedTCPPorts = [
        22 # ssh
        80 # traefik
        443 # traefik

        4240 # cilium health checks
        10250 # k3s kublet metrics
      ];

      extraCommands = ''
        iptables -A INPUT -s 10.42.0.0/16 -j ACCEPT
        iptables -A INPUT -s 10.43.0.0/16 -j ACCEPT
      '';

      trustedInterfaces = [
        "cilium_host"
        "cilium_net"
        "cilium_vxlan"
      ];

    };

    interfaces.ens18.ipv4.addresses = [
      {
        address = builtins.elemAt ipv4 0;
        prefixLength = lib.strings.toIntBase10 (builtins.elemAt ipv4 1);
      }
    ];

    defaultGateway = {
      address = terraform.gateway;
      interface = "ens18";
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    browseDomains = [ terraform.domain ];

    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  system.stateVersion = "25.11";
}
