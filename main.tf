resource "azurerm_private_dns_zone" "dns_zone" {
  for_each            = { for k in var.private_dns_zones : k.name => k }
  name                = each.key
  resource_group_name = var.resource_group_name

  tags = var.tags
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

resource "azurerm_private_dns_resolver" "dns_resolver" {
  for_each            = var.dns_resolver == null ? [] : [var.dns_resolver]
  name                = var.dns_resolver.name
  resource_group_name = var.resource_group_name
  location            = data.azurerm_virtual_network.virtual_network.location
  virtual_network_id  = data.azurerm_virtual_network.virtual_network.id

  tags = var.tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "example" {
  for_each                = var.dns_resolver == null ? [] : [var.dns_resolver]
  name                    = var.dns_resolver.inbound_endpoint_name
  private_dns_resolver_id = azurerm_private_dns_resolver.dns_resolver[0].id
  location                = data.azurerm_virtual_network.virtual_network.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = data.azurerm_subnet.subnet.id
  }

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_link" {
  for_each              = { for k in var.private_dns_zones : k.name => k if k.link_dns_resolver_virtual_network == true }
  name                  = var.dns_resolver.virtual_network_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = each.value["name"]
  registration_enabled  = each.value["registration_enabled"]
  virtual_network_id    = data.azurerm_virtual_network.virtual_network.id

  tags = var.tags
}
