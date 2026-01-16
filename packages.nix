{ inputs, lib, ... }:
{
  perSystem =
    {
      system,
      ...
    }:
    let
      terraformConfiguration = inputs.terranix.lib.terranixConfiguration {
        inherit system;
        modules = [
          ./terraform
        ];
      };
    in
    {
      options = {
        terranix.tf.package = lib.mkOption {
          type = lib.types.package;
          description = "the terraform package to install";
        };
      };

      config = {
        packages.tfConfig = terraformConfiguration;
        packages.lxc-template = inputs.nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          format = "proxmox-lxc";
          modules = [
            ./nix/base.nix
          ];
        };
      };
    };
}
