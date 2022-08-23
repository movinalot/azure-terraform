module "module_azurerm_virtual_network" {

  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true
  } : {}

  source = "../azure/rm/azurerm_virtual_network"

  resource_group_name = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.name
  location            = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.location

  name          = format("%s_%s_%s", local.user_common["utility_vnet_name"], each.value.username, each.value.suffix)
  address_space = local.user_common["utility_vnet_address_space"]
}

output "virtual_networks" {
  value = var.enable_module_output ? module.module_azurerm_virtual_network[*] : null
}
