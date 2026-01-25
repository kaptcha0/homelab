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
    domain = "https://${domain}";
    config = {
      rocketAddress = "0.0.0.0";
      rocketPort = port;
    };

    environmentFile = config.sops.secrets.env.path;
  };

  networking.firewall.allowedTCPPorts = [ config.services.vaultwarden.config.rocketPort ];

  systemd.tmpfiles.rules = [
    "d /var/lib/vaultwarden 0770 vaultwarden vaultwarden -"
  ];
}
