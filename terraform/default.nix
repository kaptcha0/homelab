{ ... }:
{
  imports = [
    ./main.nix
    ./modules.nix
    ./variables.nix
    ./secrets.nix
    ./modules/lxcs
    ./modules/infra
  ];
}
