{
  description = "Nix flake for configuring my homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      flake-parts,
      nixpkgs,
      terranix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; }

      {
        imports = [
          ./packages.nix
          ./apps.nix
          ./devshell.nix
          ./nixos-anywhere
        ];

        perSystem =
          { pkgs, ... }:
          {
            terranix.tf.package = pkgs.opentofu;
            formatter = pkgs.nixfmt;
          };

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ];
      };
}
