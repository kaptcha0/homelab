resource "proxmox_virtual_environment_vm" "k3s_server" {
  count       = local.k3s_server_count
  name        = "k3s-server-${count.index}"
  description = var.default_comment
  tags        = ["k3s", "k3s-server", "terraform"]

  node_name = local.pm_node
  pool_id   = proxmox_virtual_environment_pool.k3s_pool.pool_id
  vm_id     = 100 + count.index


  timeout_clone       = local.vm_timeout
  timeout_create      = local.vm_timeout
  timeout_migrate     = local.vm_timeout
  timeout_reboot      = local.vm_timeout
  timeout_shutdown_vm = local.vm_timeout
  timeout_start_vm    = local.vm_timeout
  timeout_stop_vm     = local.vm_timeout

  clone {
    vm_id   = local.vm_template_id
    retries = 5
  }

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
    cores = local.k3s_server_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = local.k3s_server_memory
    floating  = local.k3s_server_memory
  }

  disk {
    interface    = "virtio0"
    datastore_id = local.vm_storage
    size         = local.k3s_server_disk_size
    iothread     = true
  }

  network_device {
    bridge  = local.vm_bridge
    vlan_id = module.shared.services_vlan.id
  }

  initialization {
    user_account {
      username = local.pm_user
      keys     = [file(local.ssh_public_key)]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  depends_on = [ proxmox_virtual_environment_container.tailscale_container ]
}

resource "proxmox_virtual_environment_vm" "k3s_agent" {
  count       = local.k3s_agent_count
  name        = "k3s-agent-${count.index}"
  description = var.default_comment
  tags        = ["k3s", "k3s-agent", "terraform"]

  node_name = local.pm_node
  pool_id   = proxmox_virtual_environment_pool.k3s_pool.pool_id
  vm_id     = 200 + count.index

  clone {
    vm_id = local.vm_template_id
  }

  agent {
    enabled = true
  }

  startup {
    order      = 3
    up_delay   = 60
    down_delay = 60
  }

  cpu {
    cores = local.k3s_agent_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = local.k3s_agent_memory
    floating  = local.k3s_agent_memory
  }

  disk {
    interface    = "virtio0"
    datastore_id = local.vm_storage
    size         = local.k3s_agent_disk_size
    iothread     = true
  }

  network_device {
    bridge  = local.vm_bridge
    vlan_id = module.shared.services_vlan.id
  }

  initialization {
    user_account {
      username = local.pm_user
      keys     = [file(local.ssh_public_key)]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  depends_on = [ proxmox_virtual_environment_vm.k3s_server ]
}
