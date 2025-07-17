resource "azurerm_dns_a_record" "a_records" {
  provider = azurerm.dns_subscription

  for_each = toset([for listener in var.agw_configuration.listeners : listener.frontend_host_name])

  name                = replace(each.value, ".${var.dns_zone_name}", "")
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = 300
  records             = [module.public_ip_address.public_ip_address]
}
