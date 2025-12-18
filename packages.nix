{ inputs, lib, ... }:
{
  perSystem =
    {
      system,
      pkgs,
      config,
      self',
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
      };
    };
}
