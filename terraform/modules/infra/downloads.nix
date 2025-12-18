{ config, lib, ... }:
let
  cfg = config.infra;
in
{
  config = {
    resource."proxmox_virtual_environment_download_file".truenas = lib.mkIf cfg.truenas.enable {
      inherit (cfg.config.proxmox) node_name;

      datastore_id = "local";
      content_type = "iso";
      url = "https://download.sys.truenas.net/TrueNAS-SCALE-Goldeye/25.10.1/TrueNAS-SCALE-25.10.1.iso";
      file_name = "truenas.iso";
    };
  };
}
