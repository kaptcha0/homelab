resource "routeros_ip_service" "disabled" {
  for_each = { "api" = 8728, "ftp" = 21, "telnet" = 23, "www" = 80, "ssh" = 22 }
  numbers  = each.key
  port     = each.value
  disabled = true
}
resource "routeros_ip_service" "enabled" {
  for_each = { "winbox" = 8291 }
  numbers  = each.key
  port     = each.value
  disabled = false
}
resource "routeros_ip_service" "ssl" {
  for_each    = { "api-ssl" = 8729, "www-ssl" = 443 }
  numbers     = each.key
  port        = each.value
  tls_version = "only-1.2"
  certificate = routeros_system_certificate.webfig.name
}
