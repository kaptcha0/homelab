{ ... }:
let
  builders = import ./../../modules/builders.nix;
  port = 9090;
  domain = "prometheus.lgtm.home.kaptcha.cc";
in
{
  environment.etc = (
    builders.consul {
      inherit port domain;
      name = "prometheus";
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
    }
  );

  services.prometheus = {
    inherit port;
    enable = true;
    extraFlags = [
      "--web.enable-remote-write-receiver"
    ];
  };
}
