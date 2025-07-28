resource "routeros_ip_firewall_filter" "forward_fasttrack_established_related" {
  action           = "fasttrack-connection"
  chain            = "forward"
  connection_state = "established,related"
  comment          = "Fast-track for established, related connections ${var.default_comment}"
}

resource "routeros_ip_firewall_filter" "forward_accept_established_related" {
  action           = "accept"
  chain            = "forward"
  connection_state = "established,related"

  comment = "Accept established, related connections ${var.default_comment}"

  depends_on = [routeros_ip_firewall_filter.forward_fasttrack_established_related]
}

resource "routeros_ip_firewall_filter" "forward_drop_invalid" {
  action           = "drop"
  chain            = "forward"
  connection_state = "invalid"
  comment          = "Drop invalid connections ${var.default_comment}"

  depends_on = [routeros_ip_firewall_filter.forward_accept_established_related]
}

resource "routeros_ip_firewall_filter" "forward_drop_new_nat" {
  action               = "drop"
  chain                = "forward"
  connection_state     = "new"
  connection_nat_state = "!dstnat"
  in_interface         = var.interfaces.wan
  comment              = "Drop access to clients behind NAT from WAN ${var.default_comment}"

  depends_on = [routeros_ip_firewall_filter.forward_drop_invalid]
}