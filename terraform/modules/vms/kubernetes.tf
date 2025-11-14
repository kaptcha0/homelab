resource "proxmox_virtual_environment_file" "modded-debian12" {
  node_name    = module.shared.proxmox_config.primary_node
  content_type = "import"
  datastore_id = module.shared.proxmox_config.storage.downloads

  source_file {
    path      = "${path.root}/files/debian-12-genericcloud-amd64-modded.qcow2"
    file_name = "debian-12-genericcloud-amd64-modded.qcow2"
  }
}

resource "proxmox_virtual_environment_file" "nixos" {
  node_name    = module.shared.proxmox_config.primary_node
  content_type = "import"
  datastore_id = module.shared.proxmox_config.storage.downloads

  source_file {
    path      = "${path.root}/files/nixos.qcow2"
    file_name = "nixos.qcow2"
  }
}

resource "proxmox_virtual_environment_vm" "k3s_server" {
  count   = var.k3s_server_count
  name    = "k3s-server-${count.index}"
  tags    = ["k3s", "k3s-server", "terraform"]

  node_name = module.shared.proxmox_config.primary_node
  pool_id   = proxmox_virtual_environment_pool.vms.pool_id


  timeout_clone       = module.shared.proxmox_config.vm_defaults.timeout
  timeout_create      = module.shared.proxmox_config.vm_defaults.timeout
  timeout_migrate     = module.shared.proxmox_config.vm_defaults.timeout
  timeout_reboot      = module.shared.proxmox_config.vm_defaults.timeout
  timeout_shutdown_vm = module.shared.proxmox_config.vm_defaults.timeout
  timeout_start_vm    = module.shared.proxmox_config.vm_defaults.timeout
  timeout_stop_vm     = module.shared.proxmox_config.vm_defaults.timeout

  serial_device {}

  agent {
    enabled = true
    timeout = "20m"
  }

  startup {
    order      = 2
    up_delay   = 60
    down_delay = 60
  }

  cpu {
    cores = var.k3s_server_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.k3s_server_memory
    floating  = var.k3s_server_memory
  }

  disk {
    interface    = "virtio0"
    datastore_id = module.shared.proxmox_config.storage.vm_disks
    import_from  = proxmox_virtual_environment_file.nixos.id
  }

  network_device {
    bridge = module.shared.proxmox_config.bridges.lan.name
  }

  initialization {
    user_account {
      username = module.shared.proxmox_config.vm_defaults.username
      keys     = [file(module.shared.proxmox_config.vm_defaults.ssh_public_key)]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

}

resource "proxmox_virtual_environment_vm" "k3s_agent" {
  count   = var.k3s_agent_count
  name    = "k3s-agent-${count.index}"
  tags    = ["k3s", "k3s-agent", "terraform"]

  node_name = module.shared.proxmox_config.primary_node
  pool_id   = proxmox_virtual_environment_pool.vms.pool_id

  depends_on = [ proxmox_virtual_environment_vm.k3s_server ]

  timeout_clone       = module.shared.proxmox_config.vm_defaults.timeout
  timeout_create      = module.shared.proxmox_config.vm_defaults.timeout
  timeout_migrate     = module.shared.proxmox_config.vm_defaults.timeout
  timeout_reboot      = module.shared.proxmox_config.vm_defaults.timeout
  timeout_shutdown_vm = module.shared.proxmox_config.vm_defaults.timeout
  timeout_start_vm    = module.shared.proxmox_config.vm_defaults.timeout
  timeout_stop_vm     = module.shared.proxmox_config.vm_defaults.timeout

  serial_device {}

  agent {
    enabled = true
  }

  startup {
    order      = 3
    up_delay   = 60
    down_delay = 60
  }

  cpu {
    cores = var.k3s_agent_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.k3s_agent_memory
    floating  = var.k3s_agent_memory
  }

  disk {
    interface    = "virtio0"
    datastore_id = module.shared.proxmox_config.storage.vm_disks
    import_from  = proxmox_virtual_environment_file.nixos.id
  }

  network_device {
    bridge = module.shared.proxmox_config.bridges.lan.name
  }

  initialization {
    user_account {
      username = module.shared.proxmox_config.vm_defaults.username
      keys     = [file(module.shared.proxmox_config.vm_defaults.ssh_public_key)]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}
