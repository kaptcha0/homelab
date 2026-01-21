{ config, ... }:
{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.env = { };

  services.traefik = {
    enable = true;
    staticConfigOptions = (fromTOML (builtins.readFile ./traefik.toml)) // {
      certificateResolvers.cloudflare.acme.storage =
        config.services.traefik.dataDir + "/certs/cloudflare-acme.json";
    };
    environmentFiles = [
      config.sops.secrets.env.path
    ];
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    8080
  ];
}
