{ config, ... }:
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
        http = "http://127.0.0.1:${toString port}/manifest.json";
        interval = "10s";
      }
    ];
  };

  system.activationScripts.hass-config = {
    text = ''
      mkdir -p /var/lib/hass
      if [ ! -f /var/lib/hass/configuration.yaml ]; then
        cp ${./configuration.yaml} /var/lib/hass/configuration.yaml
      fi
    '';
  };

  hardware.bluetooth.enable = true;

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      privileged = true;
      volumes = [
        "/var/lib/haas:/config"
        "/run/dbus:/run/dbus:ro"
      ];
      environment.TZ = config.time.timeZone;
      image = "ghcr.io/home-assistant/home-assistant:stable";
      extraOptions = [
        "--network=host"
        "--cap-add=NET_ADMIN"
        "--cap-add=NET_RAW"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];
  networking.firewall.allowedUDPPorts = [ port ];
}
