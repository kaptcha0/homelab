{ terraform, ... }:
{
  imports = [ ./configuration.nix ];
  services.k3s.serverAddr = "https://${terraform.k3s.masterIp}:6443";
}
