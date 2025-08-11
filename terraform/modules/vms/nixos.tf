resource "terraform_data" "nixos_install" {
  for_each = local.all_ips
  triggers_replace = each.value

  input = {
    user = module.shared.proxmox_config.vm_defaults.username
    host = each.value[0]
  }

  provisioner "remote-exec" {
    # This isn't strictly supported in all contexts; depending on your terraform version, remote-exec in terraform_data may need full connection info etc.
    connection {
      host = self.input.host
      type = "ssh"
      user = self.input.user
    }

    inline = [
      "curl https://raw.githubusercontent.com/elitak/NixOS-infect/master/NixOS-infect | NIX_CHANNEL=nixos-25.05 bash -x 2>&1 | tee /tmp/infect.log",
    ]
  }
}
