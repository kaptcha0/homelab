{ ... }:
{
  imports = [
    ./grafana.nix
    ./prometheus.nix
    ./alloy.nix
    ./loki.nix
  ];

  sops.defaultSopsFile = ./secret.yaml;
}
