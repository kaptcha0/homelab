{
  description = "Nix flake for configuring my homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      flake-parts,
      nixpkgs,
      terranix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem =
        { pkgs, system, ... }:
        let
          terraform = pkgs.opentofu;
          terraformConfiguration = terranix.lib.terranixConfiguration {
            inherit system;
            modules = [
              ./infra
            ];
          };
        in
        {
          packages.infra = terraformConfiguration;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              opentofu
              terragrunt
              sops
              jq
            ];

            shellHook = '''';
          };

          apps = {
            apply = {
              type = "app";
              program = toString (
                pkgs.writers.writeBash "apply" ''
                  if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
                  cp ${terraformConfiguration} config.tf.json \
                    && ${terraform}/bin/tofu init \
                    && ${terraform}/bin/tofu apply
                ''
              );
            };

            plan = {
              type = "app";
              program = toString (
                pkgs.writers.writeBash "plan" ''
                  if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
                  cp ${terraformConfiguration} config.tf.json \
                    && ${terraform}/bin/tofu init \
                    && ${terraform}/bin/tofu plan
                ''
              );
            };

            # nix run ".#destroy"
            destroy = {
              type = "app";
              program = toString (
                pkgs.writers.writeBash "destroy" ''
                  if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
                  cp ${terraformConfiguration} config.tf.json \
                    && ${terraform}/bin/tofu init \
                    && ${terraform}/bin/tofu destroy
                ''
              );
            };
          };
        };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
}
