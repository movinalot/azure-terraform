resource "azurerm_virtual_network" "virtual_network" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true
  } : {}

  resource_group_name = azurerm_resource_group.resource_group[each.value.resource_group_name].name
  location            = azurerm_resource_group.resource_group[each.value.resource_group_name].location

  name          = format("%s_%s_%s", local.user_common["utility_vnet_name"], each.value.username, each.value.suffix)
  address_space = each.value.utility_vnet_address_space
}

output "virtual_networks" {
  value = var.enable_output ? azurerm_virtual_network.virtual_network[*] : null
}
