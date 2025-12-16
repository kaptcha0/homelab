{ lib, ... }:
let
  publicKeyFile = builtins.fetchurl {
    url = "https://github.com/kaptcha0.keys";
    sha256 = "0j8njsssxjj3yb4dzydbf8z2hmpfcjjb2l5warjm8c5cngbqxi14";
  };
  publicKeys = lib.strings.removeSuffix "\n" (builtins.readFile publicKeyFile);
  defaults = {
    timeout = 60 * 20;
    username = "terranix";
    ssh_public_keys = lib.strings.splitString "\n" publicKeys;
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
}
