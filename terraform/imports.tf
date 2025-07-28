## RouterOS imports
import {
  to = module.mikrotik.routeros_system_certificate.local-root-ca-cert
  id = "*2"
}

import {
  to = module.mikrotik.routeros_system_certificate.webfig
  id = "*5"
}

import {
  to = module.mikrotik.routeros_interface_bridge.bridge
  id = "*5"
}

import {
  to = module.mikrotik.routeros_interface_bridge_port.bridge_ports["ether2"]
  id = "*0"
}

import {
  to = module.mikrotik.routeros_ip_address.lan
  id = "*2"
}

import {
  to = module.mikrotik.routeros_ip_dhcp_client.wan
  id = "*1"
}

import {
  to = module.mikrotik.routeros_interface_list.lan
  id = "*2000010"
}

import {
  to = module.mikrotik.routeros_interface_list_member.lan_bridge
  id = "*1"
}

## Proxmox imports

import {
  to = module.proxmox.proxmox_virtual_environment_vm.routeros
  id = "pve/1500"
}