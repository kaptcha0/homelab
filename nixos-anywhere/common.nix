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
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys =
    (lib.strings.splitString "\n" publicKeys) ++ (args.extraPublicKeys or [ ]); # this is used for unit-testing this module and can be removed if not needed

  services.qemuGuest.enable = true;

  sops.defaultSopsFile = ./nixos.secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/keys.txt";

  sops.secrets.server_token = { };

  services.k3s = {
    enable = true;
    tokenFile = config.sops.secrets.server_token.path;
  };

  networking = {
    hostName = terraform.hostname;
    useDHCP = false;
    # domain = terraform.domain;
    # search = [ terraform.domain "local" ];
    nameservers = terraform.dns_servers;
    enableIPv6 = false;

    firewall.enable = false;

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
