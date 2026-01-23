{ config, ... }:
let
  builders = import ./../../modules/builders.nix;
in
(builders.consul {
  name = "couchdb";
  port = config.services.couchdb.port;
  domain = "couchdb.home.kaptcha.cc";
})
// {
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.admins-config = {
    owner = config.services.couchdb.user;
    mode = "0440"; # rr-
  };

  services.consul = {
    enable = true;
    extraConfig = {
      server = false;
      datacenter = "homelab";
      retry_join = [ "traefik.service.consul" ];
    };
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
