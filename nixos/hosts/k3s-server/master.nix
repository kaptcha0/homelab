{ ... }:
{
  imports = [
    ./configuration.nix
  ];

  services.k3s.clusterInit = true;
}
