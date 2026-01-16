{ lib, ... }:
{
  imports = [
    ./main.nix
    ./modules.nix
    ./variables.nix
    ./secrets.nix
    ./modules/lxcs
    ./modules/infra
  ];

  options = {
    terranix.nixos-template = lib.mkOption {
      type = lib.types.str;
      description = "path to the nixos lxc template";
    };
  };
}
