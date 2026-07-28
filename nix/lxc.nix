{ ... }: {
  boot.isContainer = true;
  networking.useHostResolvConf = false;

  networking.useNetworkd = true;
  networking.useDHCP = true;

  systemd.network.networks."10-container-dhcp" = {
    matchConfig.Name = "*";
    networkConfig = {
      DHCP = "yes";
      DNSDefaultRoute = true;
    };
  };
  
  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];
}
