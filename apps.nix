{ ... }:
{
  perSystem =
    { pkgs, self', ... }:
    let
      tf = pkgs.opentofu;
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
                && ${tf}/bin/tofu init \
                && ${tf}/bin/tofu apply
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
                && ${tf}/bin/tofu init \
                && ${tf}/bin/tofu plan
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
                && ${tf}/bin/tofu init \
                && ${tf}/bin/tofu destroy
            ''
          );
        };
      };
    };
}
