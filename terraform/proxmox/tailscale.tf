resource "proxmox_virtual_environment_container" "tailscale_container" {
  description = "Managed by Terraform"

  node_name   = "tailscale"
  vm_id       = 1501
  tags        = ["tailscale", "terraform"]

  initialization {
    hostname = "tailscale-router"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys = [
        trimspace(tls_private_key.tailscale_container_key.public_key_openssh),
        file(local.ssh_public_key)
      ]
      password = random_password.tailscale_container_password.result
    }
  }

  network_interface {
    name   = "veth0"
    bridge = local.vm_bridge
  }

  disk {
    datastore_id = "local-lvm"
    size         = 4
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.latest_archlinux_base_lxc_img.id
    type             = "archlinux"
  }

  startup {
    order      = 2
    up_delay   = 60
    down_delay = 60
  }
}

resource "proxmox_virtual_environment_download_file" "latest_archlinux_base_lxc_img" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = local.pm_node
  file_name     = "archlinux-base_20210420-1_amd64.tar.gz"
  url          = "http://download.proxmox.com/images/system/archlinux-base_20210420-1_amd64.tar.gz"
}

resource "random_password" "tailscale_container_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "tls_private_key" "tailscale_container_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

