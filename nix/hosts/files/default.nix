{ ... }:
let
  dataDir = "/mnt/data";
in
{
  services.sftpgo = {
    inherit dataDir;
    enable = true;

    settings = {
      httpd.bindings = [
        {
          port = 8080;
          address = "0.0.0.0";
        }
      ];
      webdavd.bindings = [
        {
          port = 8081;
          address = "0.0.0.0";
        }
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0700 sftpgo sftpgo -"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8080 8081 ];
  };
}
