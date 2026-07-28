{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.root-password = {};

  sops.secrets."iwd/networks/Nyumbani.psk" = {
    path = "/var/lib/iwd/Nyumbani.psk";
    mode = "0600";
  };

  sops.secrets."iwd/networks/Nyumbani-5G.psk" = {
    path = "/var/lib/iwd/Nyumbani-5G.psk";
    mode = "0600";
  };

  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings.Settings.AutoConnect = true;

  boot.loader.systemd-boot.enable = true;

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.root-password.path;
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  services.consul.interface.advertise = "wlan0";
}
