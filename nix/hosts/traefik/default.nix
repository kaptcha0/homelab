{ config, ... }:
{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.env = {
    owner = config.users.users.traefik.name;
  };

  services.consul = {
    enable = true;
    webUi = true;
    extraConfig = {
      server = true;
      bootstrap_expect = 1;
      datacenter = "homelab";

      client_addr = "0.0.0.0";
      bind_addr = "0.0.0.0";
      ui_config.enabled = true;
    };
  };

  services.traefik = {
    enable = true;
    staticConfigOptions = (fromTOML (builtins.readFile ./traefik.toml)) // {
      certificateResolvers.cloudflare.acme.storage =
        config.services.traefik.dataDir + "/certs/cloudflare-acme.json";

      providers.consulCatalog = {
        endpoint.address = "127.0.0.1:8500";
        exposedByDefault = false;
      };
    };
    environmentFiles = [
      config.sops.secrets.env.path
    ];
  };

  networking.firewall.allowedUDPPorts = [ 8300 8301 8302 8600 ];
  networking.firewall.allowedTCPPorts = [
    # consul
    8300
    8301
    8302
    8500
    8600

    # traefik
    80
    443
    8080
  ];
}
