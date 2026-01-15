{ ... }:
{
  services.k3s.role = "server";
  services.k3s.extraFlags = [
    "--flannel-backend=none"
    "--disable-network-policy"
    "--disable=traefik"

    "--cluster-cidr=10.42.0.0/16"
    "--service-cidr=10.43.0.0/16"
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
