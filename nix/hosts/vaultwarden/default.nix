{ config, ... }: {
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.env = {};

  services.vaultwarden = {
    enable = true;
    config = {
      rocketAddress = "0.0.0.0";
      rocketPort = 8000;
      domain = "https://vaultwarden.lab.nyumbani.home";

      dataFolder = "/mnt/data/vaultwarden-data";
      attachmentsFolder = "/mnt/data/vaultwarden-attachments";
    };

    environmentFile = config.sops.secrets.env.path;
  };

  systemd.tmpfiles.rules = [
    "d /mnt/data/vaultwarden-data 770 vaultwarden vaultwarden -"
    "d /mnt/data/vaultwarden-attachments 770 vaultwarden vaultwarden -"
  ];

  networking.firewall.allowedTCPPorts = [ config.services.vaultwarden.config.rocketPort ];
}
