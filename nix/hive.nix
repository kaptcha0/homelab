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
        ];

        deployment.targetUser = "nixos";

        networking.nftables.enable = true;
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
  };
in
{
  flake.colmenaHive = hive;
  flake.nixosConfigurations = hive.nodes;
}
