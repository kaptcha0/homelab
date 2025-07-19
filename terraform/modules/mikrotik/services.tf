resource "routeros_ip_service" "disabled" {
  for_each = local.services.disabled
  numbers  = each.key
  port     = each.value
  disabled = true
}

resource "routeros_ip_service" "enabled" {
  for_each = local.services.enabled
  numbers  = each.key
  port     = each.value
  disabled = false
}