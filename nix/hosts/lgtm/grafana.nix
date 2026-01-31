{ ... }:
let
  builders = import ./../../modules/builders.nix;
  port = 3000;
  domain = "lgtm.home.kaptcha.cc";
in
{
  environment.etc = (
    builders.consul {
      inherit port domain;
      name = "grafana";
      checks = [
        {
          http = "http://127.0.0.1:${toString port}/api/health";
          interval = "10s";
        }
      ];
    }
  );

  services.grafana = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        inherit domain;
        protocol = "http";
        http_addr = "0.0.0.0";
        http_port = port;
      };
    };

    provision.datasources.settings = {
      apiVersion = 1;

      datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          orgId = 1;
          url = "http://127.0.0.1:9090";
          basicAuth = false;
          isDefault = true;
          version = 1;
          editable = false;
        }
      ];
    };
  };
}
