{ lib, ... }:
{
  perSystem =
    { pkgs, config, self', ... }:
    let
      tf = lib.getExe config.terranix.tf.package;
    in
    {

      apps = {
        default = self'.apps.apply;

        apply = {
          type = "app";
          meta.description = "provision";
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
          meta.description = "plan out modifications";
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
          meta.description = "destroy provisioned resources";
          program = toString (
            pkgs.writers.writeBash "destroy" ''
              if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
              cp ${self'.packages.tfConfig} config.tf.json \
                && ${tf} init \
                && ${tf} destroy
            ''
          );
        };

        refresh = {
          type = "app";
          meta.description = "get the tf state";
          program = toString (
            pkgs.writers.writeBash "state" ''
              if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
              cp ${self'.packages.tfConfig} config.tf.json \
                && ${tf} init \
                && ${tf} state pull
            ''
          );
        };
      };
    };
}
