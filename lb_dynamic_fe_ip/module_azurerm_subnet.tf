resource "azurerm_subnet" "subnet" {
  for_each = local.subnets

  resource_group_name = each.value.resource_group_name

  virtual_network_name = each.value.vnet_name
  name                 = each.value.name
  address_prefixes     = each.value.address_prefixes
}

output "subnets" {
  value = var.enable_output ? azurerm_subnet.subnet[*] : null
}
