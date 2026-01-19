{ config, lib, ... }:
let
  cfg = config.infra;
in
{
  config.resource = lib.mkIf cfg.truenas.enable {
    "proxmox_virtual_environment_download_file".truenas = {
      inherit (cfg.config.proxmox) node_name;

      datastore_id = "local";
      content_type = "iso";
      url = "https://download.sys.truenas.net/TrueNAS-SCALE-Goldeye/25.10.1/TrueNAS-SCALE-25.10.1.iso";
      file_name = "truenas.iso";
    };

    "proxmox_virtual_environment_file".truenas_hook = {
      inherit (cfg.config.proxmox) node_name;

      datastore_id = "local";
      content_type = "snippets";
      file_mode = "0700";

      source_raw = {
        data = builtins.readFile ./truenas-hook.sh;
        file_name = "truenas-hookscript.sh";
      };
    };
  };
}
