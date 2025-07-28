resource "routeros_ip_firewall_nat" "masquarade" {
  action        = "masquerade"
  chain         = "srcnat"
  out_interface = var.interfaces.wan
  comment       = "NAT masquerade for WAN ${var.default_comment}"
}