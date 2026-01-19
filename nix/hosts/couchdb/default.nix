{ config, ... }:
{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.admins-config = {
    owner = config.services.couchdb.user;
    mode = "0440"; # rr-
  };

  services.couchdb = {
    enable = true;
    databaseDir = "/mnt/data/couchdb";
    bindAddress = "0.0.0.0";
    port = 5984;

    extraConfig.couchdb.single_node = true;

    extraConfigFiles = [
      config.sops.secrets.admins-config.path
    ];
  };

  networking.firewall.allowedTCPPorts = [ config.services.couchdb.port ];
}
