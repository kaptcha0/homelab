{ modulesPath, lib, pkgs, ... }:
let
  publicKeyFile = builtins.fetchurl {
    url = "https://github.com/kaptcha0.keys";
    sha256 = "0j8njsssxjj3yb4dzydbf8z2hmpfcjjb2l5warjm8c5cngbqxi14";
  };
  publicKeysLines = lib.strings.splitString "\n" (builtins.readFile publicKeyFile);
  publicKeys = lib.lists.filter (line: line != "") publicKeysLines;
in
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  environment.systemPackages = with pkgs; [ vim helix ssh-to-age ];

  boot.isContainer = true;
  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  security.sudo.wheelNeedsPassword = false;

  nix = {
    settings.trusted-users = [ "nixos" ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = publicKeys;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  system.stateVersion = "25.11";
}
