variable "hosts" {
  type = map(list(string))
  description = "the list of hosts with the corresponding host names"
}


module "shared" {
  source = "../shared/"
}

module "deploy" {
  for_each = var.hosts

  source                 = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"
  nixos_system_attr      = "${path.cwd}/${path.module}#nixosConfigurations.generic.config.system.build.toplevel"
  nixos_partitioner_attr = "${path.cwd}/${path.module}#nixosConfigurations.generic.config.system.build.diskoScript"
  target_host            = each.value[0]
  # when instance id changes, it will trigger a reinstall
  instance_id            = each.value[0]
  # useful if something goes wrong
  debug_logging          = true
  # build the closure on the remote machine instead of locally
  # build_on_remote        = true

  special_args = {
    terraform = {
      # hostname = each.key
      hostname = "k3s-server-0"
      user = module.shared.proxmox_config.vm_defaults.username
    }
  }
}
