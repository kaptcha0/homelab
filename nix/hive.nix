{ inputs, ... }:
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

        sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
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
          ./hosts/netbird
        ];
      };
  };
in
{
  flake.colmenaHive = hive;
  flake.nixosConfigurations = hive.nodes;
}
