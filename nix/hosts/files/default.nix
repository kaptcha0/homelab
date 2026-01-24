{ ... }:
let
  dataDir = "/mnt/data";
  builders = import ./../../modules/builders.nix;
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

  environment.etc =
    (builders.consul rec {
      name = "sftpgo";
      port = 8080;
      domain = "files.home.kaptcha.cc";
      checks = [
        {
          http = "http://127.0.0.1:${toString port}/healthz";
          interval = "10s";
        }
      ];
    })
    // (builders.consul {
      name = "webdav";
      port = 8081;
      domain = "dav.files.home.kaptcha.cc";
      checks = [ ];
    });

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0770 sftpgo sftpgo -"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8080
      8081
    ];
  };
}
