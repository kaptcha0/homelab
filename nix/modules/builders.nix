{
  consul =
    {
      name,
      port,
      domain,
      checks ? [
        {
          http = "http://127.0.0.1:${toString port}";
          interval = "10s";
        }
      ],
      tags ? [ ],
      rules ? "",
    }:
    {
      environment.etc."consul.d/${name}.json".text = builtins.toJSON {
        service = {
          inherit name port checks;

          tags = [
            "traefik.enable=true"
            "traefik.http.routers.${name}.rule=Host(`${domain}`) ${rules}"
            "traefik.http.routers.${name}.entrypoints=web"
            "traefik.http.routers.${name}.entrypoints=websecure"
            "traefik.http.routers.${name}.tls.certresolver=cloudflare"
          ]
          ++ tags;
        };
      };

    };
}
