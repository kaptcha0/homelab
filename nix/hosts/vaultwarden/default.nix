{ config, ... }:
let
  port = 8000;
  domain = "vaultwarden.home.kaptcha.cc";
  builders = import ./../../modules/builders.nix;
in
{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.env = { };

  environment.etc = (
    builders.consul {
      inherit port domain;
      name = "vaultwarden";
    }
  );

  services.vaultwarden = {
    enable = true;
    config = {
      rocketAddress = "0.0.0.0";
      rocketPort = port;
      domain = "https://${domain}";

      dataFolder = "/mnt/data/vaultwarden-data";
      attachmentsFolder = "/mnt/data/vaultwarden-attachments";
    };

    environmentFile = config.sops.secrets.env.path;
  };

  systemd.tmpfiles.rules = [
    "d /mnt/data/vaultwarden-data 770 vaultwarden vaultwarden -"
    "d /mnt/data/vaultwarden-attachments 770 vaultwarden vaultwarden -"
  ];

  networking.firewall.allowedTCPPorts = [ config.services.vaultwarden.config.rocketPort ];
}
