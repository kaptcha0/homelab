resource "proxmox_virtual_environment_hardware_mapping_pci" "wireless" {
  comment = var.default_comment
  name    = "wireless"

  map = [
    {
      comment = "Wireless NIC"
      id      = "8086:0082"
      # This is an optional attribute, but causes a mapping to be incomplete when not defined.
      iommu_group = 15
      node        = local.pm_node
      path        = "0000:03:00.0"
      # This is an optional attribute, but causes a mapping to be incomplete when not defined.
      subsystem_id = "8086:1321"
    },
  ]
}