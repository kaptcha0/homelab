{ ... }:
let
  builders = import ./../../modules/builders.nix;
  port = 12345;
  domain = "alloy.lgtm.home.kaptcha.cc";
in
{
  environment.etc = builders.consul {
    inherit port domain;
    name = "alloy";
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
    configPath = ./alloy;
    extraFlags = [
      "--server.http.listen-addr=0.0.0.0:${toString port}"
    ];
  };

  networking.firewall.allowedTCPPorts = [ port ];
}
