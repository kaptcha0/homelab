import {
  id = "${module.shared.proxmox_config.primary_node}:vmbr0"
  to = module.infra.proxmox_virtual_environment_network_linux_bridge.bridges["uplink"]
}