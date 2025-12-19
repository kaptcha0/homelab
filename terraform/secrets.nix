{ ... }: {
  data.sops_file.secrets = {
    # relative to root, which is the repo rot
    source_file = "./terraform/terraform.secrets.yaml";
  };
}
