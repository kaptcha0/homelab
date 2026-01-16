{ config, lib, ... }:
let
  cfg = config.lxcs;
in
{
  resource."proxmox_virtual_environment_download_file".nixos-lxc-template = lib.mkIf cfg.enable {
    inherit (cfg.config.proxmox) node_name;

    datastore_id = "local";
    content_type = "vztmpl";
    url = "https://hydra.nixos.org/build/319296903/download/1/nixos-image-lxc-proxmox-25.11pre-git-x86_64-linux.tar.xz";
  };
}
