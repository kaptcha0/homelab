{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
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
