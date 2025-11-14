{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { flake-parts, terranix, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem =
        { pkgs, system, ... }:
        {
          packages.default = terranix.lib.terranixConfiguration {
            inherit system;

            modules = [
              ./main.nix
              ./variables.nix
            ];
          };

          apps = {
            apply = {
              type = "app";
              program = toString (
                pkgs.writers.writeBash "apply" ''
                  if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
                  cp ''${terraformConfiguration} config.tf.json \
                    && ''${terraform}/bin/terraform init \
                    && ''${terraform}/bin/terraform apply
                ''
              );
            };

            # nix run ".#destroy"
            destroy = {
              type = "app";
              program = toString (
                pkgs.writers.writeBash "destroy" ''
                  if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
                  cp ''${terraformConfiguration} config.tf.json \
                    && ''${terraform}/bin/terraform init \
                    && ''${terraform}/bin/terraform destroy
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
