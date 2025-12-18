{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      terraformConfiguration = inputs.terranix.lib.terranixConfiguration {
        inherit system;
        modules = [
          ./terraform
        ];
      };
    in
    {
      packages.tfConfig = terraformConfiguration;
    };
}
