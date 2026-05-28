{ ... }:
{
  imports = [
    ./grafana.nix
    ./prometheus.nix
    ./alloy.nix
    ./loki.nix
  ];
}
