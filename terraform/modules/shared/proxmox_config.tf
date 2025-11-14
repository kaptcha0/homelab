locals {
  proxmox_config = {
    primary_node = "pve"

    bridges = {
      uplink = {
        name = "vmbr0"
        address = "10.67.0.2/24"
        gateway = "10.67.0.1"
        ports = ["eno1"]
      }
      lan = {
        name = "vmbr1"
        address = "172.64.0.2/24"
        gateway = "172.64.0.1"
        ports = ["enx00051b2a4e43"]
      }
      mgmt = {
        name = "vmbr2"
        address = "172.64.99.2/24"
        gateway = "172.64.99.1"
        ports = ["wlp3s0"]
      }
    }

    storage = {
      vm_disks  = "local-lvm"
      downloads = "local"
    }

    vm_defaults = {
      username = "terraform"
      timeout  = 3600  # 60 minutes
      ssh_public_key = "~/.ssh/id_ed25519.pub"
    }

    downloads = {
      debian12 = {
        content_type = "import"
        file_name    = "debian-12-genericcloud-amd64.qcow2"
        datastore_id = "local"
        url = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
      }
    }
  }
}

output "proxmox_config" {
  value = local.proxmox_config
}
