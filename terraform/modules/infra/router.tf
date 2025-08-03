resource "proxmox_virtual_environment_vm" "routeros" {
  node_name = module.shared.proxmox_config.primary_node
  name = "routeros"

  agent {
    enabled = true
  }

  disk {
    interface = "virtio"
    datastore_id = module.shared.proxmox_config.storage.vm_disks
    import_from = proxmox_virtual_environment_file.routeros.id
  }

  network_device {
    bridge = module.shared.proxmox_config.bridges.uplink.name
  }

  network_device {
    bridge = module.shared.proxmox_config.bridges.lan.name
  }

  depends_on = [ proxmox_virtual_environment_network_linux_bridge.bridges ]
}

resource "proxmox_virtual_environment_file" "routeros" {
  node_name = module.shared.proxmox_config.primary_node
  content_type = "import"
  datastore_id = module.shared.proxmox_config.storage.downloads

  source_file {
    path = "${path.root}/files/chr-7.19.3.qcow2"
    file_name = "chr-7.19.3.qcow2"
  }
}