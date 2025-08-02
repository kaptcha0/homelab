## Proxmox imports

import {
  to = module.infra.proxmox_virtual_environment_network_linux_bridge.vmbr0
  id = "pve:vmbr0"
}

import {
  to = module.vms.proxmox_virtual_environment_vm.truenas
  id = "pve/301"
}
