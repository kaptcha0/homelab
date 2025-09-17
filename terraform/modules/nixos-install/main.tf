variable "hosts" {
  type = map(list(string))
  description = "the list of hosts with the corresponding host names"
}


module "shared" {
  source = "../shared/"
}

module "system-build" {
  for_each = var.hosts

  source            = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  # with flakes
  attribute         = "${path.cwd}/${path.module}#nixosConfigurations.generic.config.system.build.toplevel"
  # attribute         = "./${path.module}#generic.config.system.build.toplevel"
  special_args = {
    hostname = each.key
    user = module.shared.proxmox_config.vm_defaults.username
  }
  debug_logging = true
  # without flakes
  # file can use (pkgs.nixos []) function from nixpkgs
  #file              = "${path.module}/../.."
  #attribute         = "config.system.build.toplevel"
}

module "disko" {
  for_each = var.hosts

  source         = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  # with flakes
  attribute         = "${path.cwd}/${path.module}#nixosConfigurations.generic.config.system.build.toplevel"
  # attribute      = "./terraform/${path.module}#nixosConfigurations.generic.config.system.build.diskoScript"
  # without flakes
  # file can use (pkgs.nixos []) function from nixpkgs
  #file           = "${path.module}/../.."
  #attribute      = "config.system.build.diskoScript"
}

module "install" {
  for_each = var.hosts

  source            = "github.com/nix-community/nixos-anywhere//terraform/install"
  nixos_system      = module.system-build[each.key].result.out
  nixos_partitioner = module.disko[each.key].result.out
  target_host       = each.value[0]
  target_user       = module.shared.proxmox_config.vm_defaults.username
}

