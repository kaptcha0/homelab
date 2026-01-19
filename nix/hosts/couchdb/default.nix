{ config, ... }:
{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.admins-config = {
    owner = config.services.couchdb.user;
    mode = "0440"; # rr-
  };

  services.couchdb = {
    enable = true;
    databaseDir = "/mnt/data";
    bindAddress = "0.0.0.0";
    port = 5984;

    extraConfigFiles = [
      config.sops.secrets.admins-config.path
    ];
  };

  networking.firewall.allowedTCPPorts = [ config.services.couchdb.port ];
}
