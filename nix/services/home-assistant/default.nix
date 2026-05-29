{ ... }:
let
  builders = import ./../../modules/builders.nix;
  port = 8123;
  domain = "homeassistant.home.kaptcha.cc";
in
{
  environment.etc = builders.consul {
    inherit port domain;
    name = "home-assistant";
    checks = [
      {
        http = "http://127.0.0.1:${toString port}/api";
        interval = "10s";
      }
    ];
  };

  services.home-assistant = {
    enable = true;
    openFirewall = true;
    configWritable = true;
    lovelaceConfigWritable = true;

    extraComponents = [
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      "isal"
    ];

    config = {
      default_config = {};
      http.server_port = port;

      homeassistant = {
        latitude = 38.3;
        longitude =  -77.6;
        unit_system = "us_customary";
      };
    };
  };
}
