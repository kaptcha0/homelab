resource "proxmox_virtual_environment_vm" "routeros" {
  name        = "routeros"
  description = "RouterOS VM ${var.default_comment}"
  tags        = ["routeros", "mikrotik", "terraform"]
  reboot      = true

  node_name = local.pm_node
  vm_id     = 1500

  agent {
    enabled = true
  }

  startup {
    order      = 0
    up_delay   = 60
    down_delay = 60
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 1024
  }

  disk {
    interface    = "scsi0"
    datastore_id = local.vm_storage
    size         = 1
  }

  network_device {
    bridge = local.pm_bridge
  }

  network_device {
    bridge = local.vm_bridge
  }
}