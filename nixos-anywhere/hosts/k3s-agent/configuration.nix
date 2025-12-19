{ terraform, ... }: {
  services.k3s.role = "agent";
  services.k3s.serverAddr = "https://${terraform.masterIp}:6443";
}
