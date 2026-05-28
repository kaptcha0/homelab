{ inputs, lib, ... }:
{
  perSystem =
    {
      system,
      ...
    }:
    let
      lxc-template = (inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nix/base.nix
          ./nix/lxc.nix
        ];
      }).config.system.build.images.proxmox-lxc;
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
