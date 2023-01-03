resource "azurerm_private_dns_zone" "dns_zone" {
  for_each            = { for k in var.private_dns_zones : k.name => k }
  name                = each.key
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_a_record" "a_records" {
  for_each            = { for k in local.a_records : "${k.a_record_name}-${k.private_dns_zone_name}-${var.resource_group_name}" => k if k != null }
  name                = each.value["a_record_name"]
  zone_name           = azurerm_private_dns_zone.dns_zone[(each.value["private_dns_zone_name"])]
  resource_group_name = var.resource_group_name
  ttl                 = each.value["time_to_live"]
  records             = each.value["records"]
}

resource "azurerm_private_dns_cname_record" "cname_records" {
  for_each            = { for k in local.cname_records : "${k.a_record_name}-${k.private_dns_zone_name}-${var.resource_group_name}" => k if k != null }
  name                = each.value["cname_record_name"]
  zone_name           = azurerm_private_dns_zone.dns_zone[(each.value["private_dns_zone_name"])]
  resource_group_name = var.resource_group_name
  ttl                 = each.value["time_to_live"]
  record              = each.value["record"]
}
