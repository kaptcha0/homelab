{ lib, ... }:
{
  perSystem =
    { pkgs, config, self', ... }:
    let
      tf = lib.getExe config.terranix.tf.package;
    in
    {

      apps = {
        apply = {
          type = "app";
          meta.description = "run tf init and apply";
          program = toString (
            pkgs.writers.writeBash "apply" ''
              if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
              cp ${self'.packages.tfConfig} config.tf.json \
                && ${tf} init \
                && ${tf} apply
            ''
          );
        };

        plan = {
          type = "app";
          meta.description = "run tf init and plan";
          program = toString (
            pkgs.writers.writeBash "plan" ''
              if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
              cp ${self'.packages.tfConfig} config.tf.json \
                && ${tf} init \
                && ${tf} plan
            ''
          );
        };

        destroy = {
          type = "app";
          meta.description = "run tf init and destroy";
          program = toString (
            pkgs.writers.writeBash "destroy" ''
              if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
              cp ${self'.packages.tfConfig} config.tf.json \
                && ${tf} init \
                && ${tf} destroy
            ''
          );
        };
      };
    };
}
