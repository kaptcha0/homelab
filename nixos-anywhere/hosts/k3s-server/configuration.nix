{ ... }:
{
  services.k3s.role = "server";
  services.k3s.extraFlags = [
    "--flannel-backend=none"
    "--disable-network-policy"
    "--disable=traefik"
  ];

  networking.firewall = {
    allowedTCPPorts = [ 6443 ];
    allowedTCPPortRanges = [
      {
        from = 2379;
        to = 2380;
      } # cilium etcd access
    ];
  };
}
