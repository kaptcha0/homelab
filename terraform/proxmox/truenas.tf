resource "proxmox_virtual_environment_vm" "truenas" {
  name        = "truenas"
  description = var.default_comment
  tags        = ["truenas", "terraform"]

  node_name = local.pm_node
  vm_id     = 301

  scsi_hardware = "virtio-scsi-single"

  agent {
    enabled = true
  }

  startup {
    order      = 1
    up_delay   = 60
    down_delay = 60
  }

  cpu {
    cores   = 4
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = 8192
  }

  disk {
    interface    = "scsi0"
    datastore_id = local.vm_storage
    size         = 32
    iothread     = true
  }

  disk {
    interface    = "scsi1"
    datastore_id = local.vm_storage
    size         = 256
  }

  disk {
    interface    = "scsi2"
    datastore_id = local.vm_storage
    size         = 256
  }

  network_device {
    bridge  = local.vm_bridge
    vlan_id = module.shared.storage_vlan.id
  }

  initialization {
    user_account {
      username     = "root"
      keys = [file(local.ssh_public_key)]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
  
}