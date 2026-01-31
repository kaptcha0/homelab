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
      enableTraefik ? true,
      tags ? [ ],
      rules ? "",
    }:
    {
      "consul.d/${name}.json".text = builtins.toJSON {
        service = {
          inherit name port checks;

          tags =
            if enableTraefik then
              (
                [
                  "traefik.enable=true"
                  "traefik.http.routers.${name}.rule=Host(`${domain}`) ${rules}"
                  "traefik.http.routers.${name}.entrypoints=web"
                  "traefik.http.routers.${name}.entrypoints=websecure"
                  "traefik.http.routers.${name}.tls.certresolver=cloudflare"
                ]
                ++ tags
              )
            else
              [ ];
        };
      };

    };
}
