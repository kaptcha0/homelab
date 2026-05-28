{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.root-password = {};

  boot.loader.systemd-boot.enable = true;

  networking.networkmanager.enable = true;

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.root-password.path;
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  services.consul.interface.advertise = "wlp2s0";
}
