{
  description = "Nix flake for configuring my homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # used to install nixos on client machines
    nixos-install = {
      # or relative path:
      url = "./terraform/modules/nixos-install";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      nixos-install,
      ...
    }:
    {
      # Forward or expose nixosConfigurations from subflake if desired:
      nixosConfigurations = {
        # Alias or expose subflake configuration here:
        generic = nixos-install.nixosConfigurations.generic;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            mise
            opentofu
            terragrunt
            sops
            winbox4
            guestfs-tools
            jq
          ];

          shellHook = ''
            if [ -z "$NU_ALREADY_ENTERED" ]; then
              export NU_ALREADY_ENTERED=1
              exec nu
            fi
          '';
        };

      }
    );
}
