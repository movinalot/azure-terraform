module "module_azurerm_role_assignment" {

  count = length(local.user_role_definition_names)

  source = "../azure/rm/azurerm_role_assignment"

  scope                = module.module_azurerm_resource_group[element(local.user_role_definition_names[count.index], 0).name].resource_group.id
  role_definition_name = element(local.user_role_definition_names[count.index], 1)
  principal_id         = module.module_azuread_user[element(local.user_role_definition_names[count.index], 0).name].user.id
}

output "role_assignments" {
  value = var.enable_module_output ? module.module_azurerm_role_assignment[*] : null
}

output "user_role_definition_names" {
  value = local.user_role_definition_names
}