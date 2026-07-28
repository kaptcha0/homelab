{ ... }: {
  boot.isContainer = true;
  networking.useHostResolvConf = false;

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];
}
