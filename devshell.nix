{ ... }:
{
  perSystem =
    { pkgs, config, ... }:
    {

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          config.terranix.tf.package
          terragrunt
          sops
          age
          jq
        ];
      };
    };
}
