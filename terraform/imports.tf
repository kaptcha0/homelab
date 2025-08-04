import {
  id = "${module.shared.proxmox_config.primary_node}:vmbr0"
  to = module.infra.proxmox_virtual_environment_network_linux_bridge.uplink
}

## RouterOS imports
import {
  to = module.routeros.routeros_system_certificate.local-root-ca-cert
  id = "*1"
}

import {
  to = module.routeros.routeros_system_certificate.webfig
  id = "*2"
}

import {
  for_each = {
    ether3       = { id = "*0" }
  }
  to = module.routeros.routeros_interface_bridge_port.bridge_ports[each.key]
  id = each.value.id
}

import {
  for_each = {
    99 = { id = "*2" }
  }
  to = module.routeros.routeros_ip_address.ips[each.key]
  id = each.value.id
}

import {
  for_each = {
    99 = { id = "*3" }
  }
  to = module.routeros.routeros_interface_bridge_vlan.lan_bridge_autotagged_vlans[each.key]
  id = each.value.id
}

import {
  for_each = {
    99 = { id = "*6" }
  }
  to = module.routeros.routeros_interface_vlan.vlans[each.key]
  id = each.value.id
}

import {
  to = module.routeros.routeros_ip_pool.lan_pool["99"]
  id = "*1"
}

import {
  to = module.routeros.routeros_ip_dhcp_server.lan_dhcp["99"]
  id = "*1"
}

import {
  to = module.routeros.routeros_ip_dhcp_server_network.lan_network["99"]
  id = "*1"
}

import {
  to = module.routeros.routeros_ip_dhcp_client.wan
  id = "*1"
}

import {
  to = module.routeros.routeros_interface_bridge.lan_bridge
  id = "*5"
}