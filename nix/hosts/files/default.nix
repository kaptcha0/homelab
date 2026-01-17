{ ... }:
{
  services.sftpgo = {
    enable = true;
    dataDir = "/mnt/data";
    settings = {
      bindings = [
        {
          port = 8080;
        }
      ];
    };
  };
}
