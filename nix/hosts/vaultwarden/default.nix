{ config, ... }: {
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.env = {};

  services.vaultwarden = {
    enable = true;
    backupDir = "/mnt/data/vaultwarden-backup";
    config = {
      rocketAddress = "0.0.0.0";
      rocketPort = 8000;
      domain = "https://vaultwarden.lab.nyumbani.home";

      dataFolder = "/mnt/data/vaultwarden-data";
      attachmentsFolder = "/mnt/data/vaultwarden-attachments";
    };

    environmentFile = config.sops.secrets.env.path;
  };
}
