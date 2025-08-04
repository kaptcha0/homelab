resource "routeros_ip_tftp" "netbootxyz_bios" {
  req_filename = "netboot.xyz.kpxe"
  real_filename = "netboot.xyz.kpxe"
  allow = true
  read_only = true
}

resource "routeros_ip_dhcp_server_option" "netbootxyz_bios" {
  code = 67
  name = "pxe-bios-netboot.xyz"
  value = "'${routeros_ip_tftp.netbootxyz_bios.real_filename}'"
}

resource "routeros_ip_dhcp_server_option_set" "netbootxyz_bios" {
  name = "pxe_bios"
  options = routeros_ip_dhcp_server_option.netbootxyz_bios.id
}

resource "routeros_ip_tftp" "netbootxyz_uefi" {
  req_filename = "netboot.xyz.efi"
  real_filename = "netboot.xyz.efi"
  allow = true
  read_only = true
}

resource "routeros_ip_dhcp_server_option" "netbootxyz_uefi" {
  code = 67
  name = "pxe-uefi-netboot.xyz"
  value = "'${routeros_ip_tftp.netbootxyz_uefi.real_filename}'"
}

resource "routeros_ip_dhcp_server_option_set" "netbootxyz_uefi" {
  name = "pxe_uefi"
  options = routeros_ip_dhcp_server_option.netbootxyz_uefi.id
}

resource "routeros_ip_dhcp_server_option_matcher" "netbootxyz_uefi" {
  for_each = routeros_ip_dhcp_server.lan_dhcp
  matching_type = "exact"

  name = "netbootxyz_uefi_matcher_${each.key}"
  option_set = routeros_ip_dhcp_server_option_set.netbootxyz_uefi.name
  code = 93
  value = "0x0007"

  server = each.value.name
  address_pool = each.value.address_pool
}
