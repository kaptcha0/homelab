## RouterOS imports
import {
  to = module.mikrotik.routeros_system_certificate.local-root-ca-cert
  id = "*1"
}

import {
  to = module.mikrotik.routeros_system_certificate.webfig
  id = "*2"
}

## Proxmox imports

import {
  to = module.mikrotik.proxmox_virtual_environment_vm.routeros
  id = "pve/1500"
}

import {
  to = module.proxmox.proxmox_virtual_environment_vm.truenas
  id = "pve/301"
}
