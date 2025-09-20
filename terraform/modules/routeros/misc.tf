# resource "routeros_ip_neighbor_discovery_settings" "lan_discovery" {
#   discover_interface_list = routeros_interface_list.lan.name
# }

# resource "routeros_tool_mac_server" "mac_server" {
#   allowed_interface_list = routeros_interface_list.lan.name
# }

# resource "routeros_tool_mac_server_winbox" "winbox_mac_access" {
#   allowed_interface_list = routeros_interface_list.lan.name
# }

resource "routeros_system_identity" "identity" {
  name = "Router"
}

resource "routeros_system_clock" "timezone" {
  time_zone_name       = "America/New_York"
  time_zone_autodetect = false
}

