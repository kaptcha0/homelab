{ config, ... }:
let
  builders = import ./../../modules/builders.nix;
  port = 12345;
in
{
  environment.etc = builders.consul {
    inherit port;
    enableTraefik = false;
    name = "alloy-client-${config.networking.hostName}";
    checks = [
      {
        http = "http://127.0.0.1:${toString port}/-/healthy";
        interval = "10s";
      }
      {
        http = "http://127.0.0.1:${toString port}/-/ready";
        interval = "10s";
      }
    ];
  };

  services.alloy = {
    enable = true;
    configPath = ./config;
  };
}
