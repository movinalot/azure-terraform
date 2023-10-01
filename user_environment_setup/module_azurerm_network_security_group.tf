module "module_azurerm_network_security_group" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true
  } : {}

  source = "git::https://github.com/movinalot/azure.git//rm/azurerm_network_security_group"

  #source = "../azure/rm/azurerm_network_security_group"

  resource_group_name = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.name
  location            = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.location

  name = format("nsg-%s-%s", each.value.username, each.value.suffix)
}

output "network_security_groups" {
  value = var.enable_module_output ? module.module_azurerm_network_security_group[*] : null
}
