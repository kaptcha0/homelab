{ ... }:
let
  dataDir = "/mnt/data";
  builders = import ./../../modules/builders.nix;
in
(builders.consul {
  name = "sftpgo";
  port = 8080;
  domain = "files.home.kaptcha.cc";
})
// (builders.consul {
  name = "webdav";
  port = 8081;
  domain = "webdav.home.kaptcha.cc";
})
// {
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
