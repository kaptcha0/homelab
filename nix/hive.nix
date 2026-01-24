{ inputs, lib, ... }:
let
  hive = inputs.colmena.lib.makeHive {
    meta.nixpkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      specialArgs = {
        inherit inputs;
      };
    };

    defaults =
      { name, ... }:
      {
        imports = [
          ./base.nix
          inputs.comin.nixosModules.comin
          inputs.sops-nix.nixosModules.sops
        ];

        deployment.targetUser = "nixos";

        services.comin = {
          enable = true;
          hostname = name;
          exporter.openFirewall = true;
          remotes = [
            {
              name = "origin";
              url = "https://github.com/kaptcha0/homelab.git";
              branches.main.name = "main";
            }
          ];
        };

        services.consul = lib.mkDefault {
          enable = true;
          extraConfig = {
            server = false;
            datacenter = "homelab";
            retry_join = [ "traefik.service.consul" ];
          };
        };

        services.resolved.enable = true;
        services.resolved.settings.Resolve = {
          DNS = [ "10.67.0.5" ];
          Domains = [ "~consul" ];
        };

        sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };

    files =
      { ... }:
      {
        deployment = {
          targetHost = "files.nyumbani.home";
          tags = [
            "public"
            "storage"
          ];
        };

        imports = [
          ./hosts/files
        ];
      };

    couchdb =
      { ... }:
      {
        deployment = {
          targetHost = "couchdb.nyumbani.home";
          tags = [
            "database"
          ];
        };

        imports = [
          ./hosts/couchdb
        ];
      };

    netbird =
      { ... }:
      {
        deployment = {
          targetHost = "netbird.nyumbani.home";
          tags = [
            "networking"
            "remote-access"
          ];
        };

        imports = [
          ./hosts/netbird
        ];
      };

    vaultwarden =
      { ... }:
      {
        deployment = {
          targetHost = "vaultwarden.nyumbani.home";
          tags = [
            "public"
            "storage"
          ];
        };

        imports = [
          ./hosts/vaultwarden
        ];
      };

    traefik =
      { ... }:
      {
        deployment = {
          targetHost = "traefik.nyumbani.home";
          tags = [
            "public"
            "proxy"
          ];
        };

        imports = [
          ./hosts/traefik
        ];
      };
  };
in
{
  flake.colmenaHive = hive;
  flake.nixosConfigurations = hive.nodes;
}
