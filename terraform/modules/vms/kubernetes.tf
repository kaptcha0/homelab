resource "proxmox_virtual_environment_vm" "k3s_server" {
  count       = var.k3s_server_count
  name        = "k3s-server-${count.index}"
  tags        = ["k3s", "k3s-server", "terraform"]
  reboot      = true
  started     = false

  node_name = module.shared.proxmox_config.primary_node
  pool_id   = proxmox_virtual_environment_pool.vms.pool_id


  timeout_clone       = module.shared.proxmox_config.vm_defaults.timeout
  timeout_create      = module.shared.proxmox_config.vm_defaults.timeout
  timeout_migrate     = module.shared.proxmox_config.vm_defaults.timeout
  timeout_reboot      = module.shared.proxmox_config.vm_defaults.timeout
  timeout_shutdown_vm = module.shared.proxmox_config.vm_defaults.timeout
  timeout_start_vm    = module.shared.proxmox_config.vm_defaults.timeout
  timeout_stop_vm     = module.shared.proxmox_config.vm_defaults.timeout

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
    import_from  = var.k3s_disk_import_id
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
  count       = var.k3s_agent_count
  name        = "k3s-agent-${count.index}"
  tags        = ["k3s", "k3s-agent", "terraform"]
  reboot      = true
  started     = false

  node_name = module.shared.proxmox_config.primary_node
  pool_id   = proxmox_virtual_environment_pool.vms.pool_id

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
    import_from  = var.k3s_disk_import_id
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

  depends_on = [ proxmox_virtual_environment_vm.k3s_server ]
}
