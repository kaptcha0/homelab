locals {

  pm_node    = module.shared.proxmox_config.pm_node
  vm_storage = module.shared.proxmox_config.vm_storage
  vm_bridge  = module.shared.proxmox_config.vm_bridge
  pm_bridge  = module.shared.proxmox_config.pm_bridge


  interfaces = {
    wan        = "ether1"
    lan        = "ether2"
    lan_bridge = "lan-bridge"
  }

  network_config = {
    gateway = "10.67.0.1"
    subnet  = "10.67.0.0/24"
  }

  vlans = {
    untagged = {
      0 = module.shared.untagged_vlan,
    }
    tagged = {
      10 = module.shared.services_vlan,
      20 = module.shared.storage_vlan,
      30 = module.shared.dmz_vlan,
      40 = module.shared.remote_vlan,
      50 = module.shared.isolated_vlan,
      99 = module.shared.management_vlan
    }
  }

  all_vlans = merge(local.vlans.untagged, local.vlans.tagged)

  dhcp_leases = merge([
    for vlan_id, config in local.all_vlans : {
      for ip, lease in config.static_leases :
      ip => {
        mac  = lease.mac
        name = lease.name
        vlan = vlan_id
      }
    }
  ]...)
}
