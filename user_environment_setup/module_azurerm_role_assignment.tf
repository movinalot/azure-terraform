module "module_azurerm_role_assignment" {
  for_each = local.user_resource_group_roles_map

  source = "git::https://github.com/movinalot/azure.git//rm/azurerm_role_assignment"

  #source = "../azure/rm/azurerm_role_assignment"

  scope                = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.id
  role_definition_name = each.value.role_definition_name
  principal_id         = module.module_azuread_user[each.value.username].user.id
}

output "role_assignments" {
  value = var.enable_module_output ? module.module_azurerm_role_assignment[*] : null
}

output "user_resource_group_roles_list" {
  value = var.enable_module_output ? local.user_resource_group_roles_list : null
}

output "user_resource_group_roles_map" {
  value = var.enable_module_output ? local.user_resource_group_roles_map : null
}
