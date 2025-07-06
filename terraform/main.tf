provider "proxmox" {
  endpoint = var.pm_api_url

  api_token = local.pm_api_token
  insecure  = true

  ssh {
    agent    = true
    username = var.pm_user
  }
}

provider "sops" {}

resource "proxmox_virtual_environment_vm" "k3s_server" {
  count       = var.k3s_server_count
  name        = "k3s-server-${count.index}"
  description = "managed by terraform"
  tags        = ["k3s", "k3s-server", "terraform"]

  node_name = var.pm_node
  pool_id   = proxmox_virtual_environment_pool.k3s_pool.pool_id
  vm_id     = 100 + count.index


  timeout_clone       = var.vm_timeout
  timeout_create      = var.vm_timeout
  timeout_migrate     = var.vm_timeout
  timeout_reboot      = var.vm_timeout
  timeout_shutdown_vm = var.vm_timeout
  timeout_start_vm    = var.vm_timeout
  timeout_stop_vm     = var.vm_timeout

  clone {
    vm_id   = var.vm_template_id
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
    cores = var.k3s_server_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.k3s_server_memory
    floating  = var.k3s_server_memory
  }

  disk {
    interface    = "virtio0"
    datastore_id = var.vm_storage
    size         = var.k3s_server_disk_size
    iothread     = true
  }

  network_device {
    bridge = var.vm_bridge
  }

  initialization {
    user_account {
      username = var.pm_user
      keys     = [file(var.ssh_public_key)]
    }

    ip_config {
      ipv4 {
        address = "10.10.10.${10 + count.index}/24"
        gateway = "10.10.10.1"
      }
    }
  }

}

resource "proxmox_virtual_environment_vm" "k3s_agent" {
  count       = var.k3s_agent_count
  name        = "k3s-agent-${count.index}"
  description = "managed by terraform"
  tags        = ["k3s", "k3s-agent", "terraform"]

  node_name = var.pm_node
  pool_id   = proxmox_virtual_environment_pool.k3s_pool.pool_id
  vm_id     = 200 + count.index

  clone {
    vm_id = var.vm_template_id
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
    cores = var.k3s_agent_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.k3s_agent_memory
    floating  = var.k3s_agent_memory
  }

  disk {
    interface    = "virtio0"
    datastore_id = var.vm_storage
    size         = var.k3s_agent_disk_size
    iothread     = true
  }

  network_device {
    bridge = var.vm_bridge
  }

  initialization {
    user_account {
      username = var.pm_user
      keys     = [file(var.ssh_public_key)]
    }

    ip_config {
      ipv4 {
        address = "10.10.10.${50 + count.index}/24"
        gateway = "10.10.10.1"
      }
    }
  }

}
