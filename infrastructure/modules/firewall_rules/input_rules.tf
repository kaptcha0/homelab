resource "routeros_ip_firewall_filter" "input_accept_established_related_untracked" {
  action           = "accept"
  chain            = "input"
  connection_state = "established,related,untracked"

  comment = "Accept established, related, untracked connections ${var.default_comment}"
}

resource "routeros_ip_firewall_filter" "input_drop_invalid" {
  action           = "drop"
  chain            = "input"
  connection_state = "invalid"
  comment          = "Drop invalid connections ${var.default_comment}"

  depends_on = [routeros_ip_firewall_filter.input_accept_established_related_untracked]
}

resource "routeros_ip_firewall_filter" "input_accept_icmp" {
  action       = "accept"
  chain        = "input"
  in_interface = var.interfaces.wan
  protocol     = "icmp"

  log     = true
  comment = "Accept ICMP traffic ${var.default_comment}"

  depends_on = [routeros_ip_firewall_filter.input_drop_invalid]
}

resource "routeros_ip_firewall_filter" "input_allow_winbox" {
  action       = "accept"
  chain        = "input"
  in_interface = var.interfaces.wan
  protocol     = "tcp"
  dst_port     = 8291

  log     = true
  comment = "Allow Winbox on WAN interface ${var.default_comment}"

  depends_on = [routeros_ip_firewall_filter.input_accept_icmp]
}

resource "routeros_ip_firewall_filter" "input_drop_everything" {
  action       = "drop"
  chain        = "input"
  in_interface = var.interfaces.wan
  comment      = "Drop everything on WAN interface ${var.default_comment}"

  depends_on = [routeros_ip_firewall_filter.input_allow_winbox]
}