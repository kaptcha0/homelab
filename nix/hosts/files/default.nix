{ ... }:
{
  services.sftpgo = {
    enable = true;
    dataDir = "/mnt/data";
    settings = {
      httpd.bindings = [
        {
          port = 8080;
          address = "0.0.0.0";
        }
      ];
      webdavd.bindings = [
        {
          port = 8080;
          address = "0.0.0.0";
        }
      ];
    };
  };
}
