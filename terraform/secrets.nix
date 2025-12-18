{ ... }: {
  data.sops_file.secrets = {
    # relative to root, which is the repo rot
    source_file = "./secrets/terraform-secrets.yaml";
  };
}
