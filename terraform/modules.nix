{ lib, ... }:
let
  defaults = {
    timeout = 60 * 20;
    username = "terranix";
    ssh_public_key = ./modules.nix;
    lan_name = "";
  };
in
{
  vms.k3s = {
    enable = true;

    config = {
      inherit defaults;

      proxmox = {
        node_name = "pve";
        datastore_id = "local-lvm";
      };

      server = {
        count = 1;
        cores = 2;
        memory = 2048;
      };

      agent = {
        count = 2;
        cores = 2;
        memory = 2048;
      };
    };
  };

  module = {
    shared.source = "./modules/shared/";
    infra.source = "./modules/infra/";

    routeros = {
      source = "./modules/routeros/";
      default_comment = "(managed by terraform)";
      depends_on = [
        "module.infra"
      ];
    };

  };
}
