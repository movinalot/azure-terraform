module "module_azurerm_subnet" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_subnets_map : name => user
    if user.bastion == true
  } : {}

  source = "../azure/rm/azurerm_subnet"

  resource_group_name = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.name

  name             = each.value.subnet_name
  vnet_name        = module.module_azurerm_virtual_network[each.value.resource_group_name].virtual_network.name
  address_prefixes = each.value.subnet_address_prefixes
}

output "subnets" {
  value = var.enable_module_output ? module.module_azurerm_subnet[*] : null
}

output "user_resource_group_subnets_list" {
  value = var.enable_module_output ? local.user_resource_group_subnets_list : null
}

output "user_resource_groups_subnets_map" {
  value = var.enable_module_output ? local.user_resource_groups_subnets_map : null
}