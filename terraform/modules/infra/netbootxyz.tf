resource "proxmox_virtual_environment_vm" "netbootxyz" {
  node_name = module.shared.proxmox_config.primary_node
  tags      = ["terraform"]
  pool_id   = proxmox_virtual_environment_pool.networking.pool_id
  name      = "netbootxyz"
  reboot    = true
  started   = false

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

  network_device {
    bridge      = proxmox_virtual_environment_network_linux_bridge.lan.name
    mac_address = "ea:bf:7a:11:7e:92"
  }

  memory {
    dedicated = 2048
  }

  disk {
    interface    = "virtio0"
    datastore_id = module.shared.proxmox_config.storage.vm_disks
    import_from  = proxmox_virtual_environment_download_file.downloads["debian12"].id
    size         = 12
  }

  initialization {
    user_account {
      username = "netbootxyz"
      keys     = [file(module.shared.proxmox_config.vm_defaults.ssh_public_key)]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}
