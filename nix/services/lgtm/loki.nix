{ ... }:
let
  builders = import ./../../modules/builders.nix;
  port = 9091;
in
{
  environment.etc = (
    builders.consul {
      inherit port;
      enableTraefik = false;
      name = "loki";
      checks = [
        {
          http = "http://127.0.0.1:${toString port}/-/healthy";
          interval = "10s";
        }
        {
          http = "http://127.0.0.1:${toString port}/-/ready";
          interval = "10s";
        }
      ];
    }
  );

  services.loki = {
    enable = true;
    configuration =
      let
        path = "/var/lib/loki";
      in
      {
        auth_enabled = false;
        server.http_listen_port = port;

        common = {
          replication_factor = 1;
          ring.kvstore.store = "inmemory";

          path_prefix = path;

          storage.filesystem = {
            chunks_directory = path + "/chunks";
            rules_directory = path + "/rules";
          };
        };

        schema_config.configs = [
          {
            from = "2026-06-30";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];

        limits_config = {
          retention_period = (toString (30 * 24)) + "h";
          reject_old_samples = true;
          reject_old_samples_max_age = (toString (7 * 24)) + "h";
          max_streams_per_user = 0;
          ingestion_rate_mb = 16;
          ingestion_burst_size_mb = 32;
        };

        compactor = {
          working_directory = path + "/compactor";
          compaction_interval = "10m";
          retention_enabled = true;
          retention_delete_delay = "2h";
          delete_request_store = "filesystem";
        };
      };
  };

  networking.firewall.allowedTCPPorts = [ port ];
}
