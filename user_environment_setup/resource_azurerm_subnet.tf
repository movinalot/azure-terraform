resource "azurerm_subnet" "subnet" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_subnets_map : name => user
    if user.bastion == true
  } : {}

  resource_group_name = azurerm_resource_group.resource_group[each.value.resource_group_name].name

  name                 = each.value.subnet_name
  virtual_network_name = azurerm_virtual_network.virtual_network[each.value.resource_group_name].name
  address_prefixes     = each.value.subnet_address_prefixes
}

output "subnets" {
  value = var.enable_output ? azurerm_subnet.subnet[*] : null
}

output "user_resource_group_subnets_list" {
  value = var.enable_output ? local.user_resource_group_subnets_list : null
}

output "user_resource_groups_subnets_map" {
  value = var.enable_output ? local.user_resource_groups_subnets_map : null
}
