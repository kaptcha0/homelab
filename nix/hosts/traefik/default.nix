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
    staticConfigOptions = {
      global.sendAnonymousUsage = false;
      log.level = "DEBUG";

      api = {
        dashboard = true;
        insecure = true;
      };

      entrypoints = {
        websecure.address = ":443";

        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
            permanent = true;
          };
        };
      };

      certificatesResolvers.cloudflare.acme = {
        email = "info@kaptcha.cc";
        caServer = "https://acme-v02.api.letsencrypt.org/directory";
        keyType = "EC256";
        storage = config.services.traefik.dataDir + "/cloudflare-acme.json";

        dnsChallenge.provider = "cloudflare";
        dnsChallenge.resolvers = [
          "1.1.1.1:53"
          "8.8.8.8:53"
        ];
      };

      providers.consulCatalog = {
        endpoint.address = "127.0.0.1:8500";
        exposedByDefault = false;
      };
    };
    environmentFiles = [
      config.sops.secrets.env.path
    ];
  };

  networking.firewall.allowedUDPPorts = [
    8300
    8301
    8302
    8600
  ];
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
