variable "hosts" {
  type = map(list(string))
  description = "the hosts to connect to"
}

locals {
  time = "2025-09-19T19:32:13.613688874-04:00"
}

module "shared" {
  source = "../shared"
}

resource "time_sleep" "wait_before_module" {
  for_each = var.hosts
  create_duration = "60s" # Waits for 60 seconds

  triggers = merge({
    for ip in each.value :
    "${each.key}-${ip}" => ip
  }, {
    timestamp = local.time
  })
}

resource "null_resource" "copy_configs" {
  for_each = var.hosts
  depends_on = [ time_sleep.wait_before_module ]

  triggers = {
    ip = each.value[0]
    timestamp = local.time
  }

  connection {
    type    = "ssh"
    user    = module.shared.proxmox_config.vm_defaults.username
    host    = each.value[0]
  }

  provisioner "file" {
    source      = "${abspath(path.module)}/qemu.nix"
    destination = "/tmp/qemu.nix"
  }
}

resource "null_resource" "nixos_install" {
  for_each = var.hosts

  depends_on = [ null_resource.copy_configs ]

  triggers = {
    ip = each.value[0]
    timestamp = local.time
  }

  connection {
    type    = "ssh"
    user    = module.shared.proxmox_config.vm_defaults.username
    host    = each.value[0]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash <<EOF",
        "curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIXOS_IMPORT=/tmp/qemu.nix NIX_CHANNEL=nixos-25.05 bash -x",
        "exit 0",
      "EOF"
    ]
  }
}
