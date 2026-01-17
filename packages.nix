{ inputs, lib, ... }:
{
  perSystem =
    {
      system,
      ...
    }:
    let
      lxc-template = inputs.nixos-generators.nixosGenerate {
        inherit system;
        format = "proxmox-lxc";
        modules = [
          ./nix/base.nix
        ];
      };
      terraformConfiguration = inputs.terranix.lib.terranixConfiguration {
        inherit system;
        modules = [
          ./terraform
          {
            terranix.nixos-template = "${lxc-template}/tarball/${lxc-template.fileName}.tar.xz";
          }
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
        packages.lxc-template = lxc-template;
      };
    };
}
