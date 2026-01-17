{ inputs, ... }:
{
  flake.colmenaHive = inputs.colmena.lib.makeHive {
    meta.nixpkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
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

        services.comin = {
          enable = true;
          hostname = name;
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
          inputs.filestash.nixosModules.filestash
        ];
      };
  };
}
