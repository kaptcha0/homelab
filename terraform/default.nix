{ ... }:
{
  imports = [
    ./main.nix
    ./modules.nix
    ./variables.nix
    ./secrets.nix
    ./modules/vms
    ./modules/infra
    ./modules/nixos-anywhere
  ];
}
