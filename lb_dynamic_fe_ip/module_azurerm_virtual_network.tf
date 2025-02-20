resource "azurerm_virtual_network" "virtual_network" {
  for_each = local.virtual_networks

  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  name          = each.value.name
  address_space = each.value.address_space
}


output "virtual_networks" {
  value = var.enable_output ? azurerm_virtual_network.virtual_network[*] : null
}
