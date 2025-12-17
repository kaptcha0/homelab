{ ... }: {
  data.sops_file.secrets = {
    source_file = "../secrets/terraform-secrets.yaml";
  };
}
