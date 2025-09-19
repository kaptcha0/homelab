{
  modulesPath,
  lib,
  pkgs,
  ...
}@args:
let
  hostname = args.terraform.hostname;
  user = args.terraform.user;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  networking.hostName = hostname;
  networking.interfaces.eth0.useDHCP = true;

  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/kaptcha0/homelab.git";
        branches.main.name = "main";
        flakeSubdirectory = "nixos";
      }
    ];
  };

  users.users.${user}.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    builtins.readFile /home/kaptcha0/.ssh/id_ed25519
  ]
  ++ (args.extraPublicKeys or [ ]); # this is used for unit-testing this module and can be removed if not needed

  system.stateVersion = "24.05";
}
