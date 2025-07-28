resource "proxmox_virtual_environment_vm" "routeros" {
  name        = "routeros"
  description = "RouterOS VM ${var.default_comment}"
  tags        = ["routeros", "mikrotik", "terraform"]

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
    dedicated = 256
  }

  disk {
    datastore_id = local.pm_storage
    interface    = "scsi0"
    import_from  = proxmox_virtual_environment_file.routeros_img.id
    size         = 8
  }

  serial_device {}

  network_device {
    bridge = proxmox_virtual_environment_network_linux_bridge.wan.name
  }

  network_device {
    bridge = proxmox_virtual_environment_network_linux_bridge.lan.name
  }

  network_device {
    bridge = proxmox_virtual_environment_network_linux_bridge.mgmt.name
  }
}

resource "proxmox_virtual_environment_file" "routeros_img" {
  node_name    = local.pm_node
  datastore_id = local.pm_storage
  content_type = "import"

  source_file {
    path = "${path.root}/files/routeros-7.19.3.qcow2"
  }
}
