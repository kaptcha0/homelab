{
  consul =
    { name, port, domain }:
    {
      environment.etc."consul.d/${name}.json".text = builtins.toJSON {
        service = {
          name = name;
          port = port;

          checks = [
            {
              http = "http://127.0.0.1:${toString port}";
              interval = "10s";
            }
          ];

          tags = [
            "traefik.enable=true"
            "traefik.http.routers.vaultwarden.rule=${domain}"
            "traefik.http.routers.vaultwarden.entrypoints=web"
            "traefik.http.routers.vaultwarden.entrypoints=websecure"
            "traefik.http.routers.vaultwarden.tls.certresolver=cloudflare"
          ];
        };
      };

    };
}
