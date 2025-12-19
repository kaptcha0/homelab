{ ... }:
{
  services.k3s.role = "server";
  services.k3s.extraFlags = [
    "--flannel-backend=none"
    "--disable-network-policy"
  ];
}
