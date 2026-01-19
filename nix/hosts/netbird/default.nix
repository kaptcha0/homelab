{ config, pkgs, ... }:
{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.setup-key = {
  };

  services.netbird = {
    enable = true;
    useRoutingFeatures = "client";
  };

  systemd.services.netbird-init = {
    description = "Auto-configure NetBird with Setup Key";

    # Run this after the main netbird daemon is ready
    wants = [ "netbird.service" ];
    after = [
      "netbird.service"
      "network-online.target"
    ];
    wantedBy = [ "multi-user.target" ];

    script = ''
      export NB_SETUP_KEY=`cat ${config.sops.secrets.setup-key.path}`
      ${pkgs.netbird}/bin/netbird up
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
      Group = "root";
    };
  };
}
