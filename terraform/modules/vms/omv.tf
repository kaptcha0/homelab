resource "proxmox_virtual_environment_vm" "omv" {
  name        = "omv"
  description = "OpenMediaVault VM managed by Terraform"
  tags       = ["storage", "terraform"]
  node_name  = module.shared.proxmox_config.primary_node
  pool_id    = proxmox_virtual_environment_pool.vms.pool_id

  agent {
    enabled = true
  }

  startup {
    order      = 1
    up_delay   = 60
    down_delay = 60
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
    floating  = 2048
  }

  disk {
    interface    = "virtio0"
    datastore_id = module.shared.proxmox_config.storage.vm_disks
    import_from  = var.omv_iso_import_id
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