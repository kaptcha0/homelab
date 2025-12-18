{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      tf = pkgs.opentofu;
    in
    {

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          tf
          terragrunt
          sops
          jq
        ];

        shellHook = '''';
      };
    };
}
