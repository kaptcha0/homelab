{ inputs, ... }:
{
  flake.colmenaHive = inputs.colmena.lib.makeHive {
    meta.nixpkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
    };
  };

  defaults =
    { ... }:
    {
      imports = [
        ./base.nix
        inputs.comin.nixosModules.comin
      ];

      services.comin = {
        enable = true;
        remotes = [
          {
            name = "origin";
            url = "https://github.com/kaptcha0/homelab.git";
            branches.main.name = "main";
          }
        ];
      };
    };
}
