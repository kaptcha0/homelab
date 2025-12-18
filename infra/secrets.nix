{ ... }: {
  data.sops_file.secrets = {
    source_file = "./infra/secrets/terraform-secrets.yaml";
  };
}
