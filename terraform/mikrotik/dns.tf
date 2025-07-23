resource "routeros_ip_dns_record" "router" {
  name    = "router.home"
  address = "10.67.0.1"
  type    = "A"
}

resource "routeros_ip_dns_record" "pve" {
  name    = "pve.home"
  address = "10.67.0.3"
  type    = "A"
}

resource "routeros_ip_dns_record" "wifi_ap" {
  name    = "wifi_ap.home"
  address = "10.67.0.2"
  type    = "A"
}

resource "routeros_ip_dns_record" "kaptcha" {
  name    = "kaptcha.home"
  address = "10.67.0.100"
  type    = "A"
}