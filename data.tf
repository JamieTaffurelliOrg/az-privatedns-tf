data "azurerm_virtual_network" "virtual_network" {
  for_each            = var.dns_resolver == null ? [] : [var.dns_resolver]
  name                = var.dns_resolver.virtual_network_name
  resource_group_name = var.dns_resolver.virtual_network_name_resource_group_name
}

data "azurerm_subnet" "subnet" {
  for_each             = var.dns_resolver == null ? [] : [var.dns_resolver]
  name                 = var.dns_resolver.subnet_name
  virtual_network_name = var.dns_resolver.virtual_network_name
  resource_group_name  = var.dns_resolver.virtual_network_name_resource_group_name
}
