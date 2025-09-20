locals {
  interfaces = {
    wan        = "ether1"
    lan        = "ether2"
    mgmt       = "ether3"
    lan_bridge = "lan-bridge"
  }

  network_config = {
    gateway = "172.64.0.1"
    subnet  = "172.64.0.0/24"
  }

  vlans = {
    autotagged = {
      1  = merge(module.shared.untagged_vlan, { untagged_interface = local.interfaces.lan }),
      99 = merge(module.shared.management_vlan, { untagged_interface = local.interfaces.mgmt })
    }
    tagged = {
      10 = module.shared.services_vlan,
      20 = module.shared.storage_vlan,
      30 = module.shared.dmz_vlan,
      40 = module.shared.remote_vlan,
      50 = module.shared.isolated_vlan,
    }
  }

  all_vlans = merge(local.vlans.autotagged, local.vlans.tagged)

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
