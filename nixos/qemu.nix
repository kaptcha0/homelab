{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  services.qemuGuest.enable = true; # Enables the QEMU guest agent
  boot.kernelParams = [ "console=ttyS0,115200" ]; # For headless QEMU operation
  # ...
}
