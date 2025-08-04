resource "proxmox_virtual_environment_vm" "netbootxyz" {
  node_name = module.shared.proxmox_config.primary_node
  tags      = ["terraform"]
  pool_id   = proxmox_virtual_environment_pool.networking.pool_id
  name      = "netbootxyz"
  reboot    = true
  started   = false

  agent {
    enabled = true
  }

  network_device {
    bridge = proxmox_virtual_environment_network_linux_bridge.lan.name
    mac_address = "ea:bf:7a:11:7e:92"
  }

  memory {
    dedicated = 2048
  }

  disk {
    interface   = "virtio0"
    datastore_id = module.shared.proxmox_config.storage.vm_disks
    import_from = proxmox_virtual_environment_download_file.downloads["debian12"].id
    size = 12
  }

  initialization {
    user_account {
      username = "netbootxyz"
      keys = [file(module.shared.proxmox_config.vm_defaults.ssh_public_key)]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}