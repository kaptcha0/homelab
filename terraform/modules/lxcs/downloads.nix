{ config, lib, ... }:
let
  cfg = config.lxcs;
in
{
  options.lxcs.config.nixos-template = lib.mkOption {
    type = lib.types.str;
    description = "the path to the nixos lxc template";
  };

  config.resource."proxmox_virtual_environment_file".nixos-lxc-template = lib.mkIf cfg.enable {
    inherit (cfg.config.proxmox) node_name;

    datastore_id = "local";
    content_type = "vztmpl";

    source_file.path = cfg.config.nixos-template;
  };
}
