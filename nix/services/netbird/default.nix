{ config, ... }:
{
  sops.secrets.setup-key = {
    sopsFile = ./secrets.yaml;
  };

  services.resolved.enable = true;

  services.netbird = {
    enable = true;
    useRoutingFeatures = "both";
  };

  services.netbird.clients.wt0 = {
    login = {
      enable = true;
      setupKeyFile = config.sops.secrets.setup-key.path;
    };

    port = 51820;
    openFirewall = true;
    openInternalFirewall = true;
  };
}
