{ ... }: {
  imports = [
    ./downloads.nix
    ./k3s.nix
    ./cloud-config.nix
  ];
}
