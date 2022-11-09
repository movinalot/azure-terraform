resource "azurerm_role_assignment" "role_assignment_application" {
  for_each = local.per_user_service_principal ? local.user_resource_groups_map : {}

  scope                = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.id
  role_definition_name = local.per_user_service_principal_role
  principal_id         = azuread_service_principal.service_principal[each.value.username].object_id
}

output "role_assignment_applications" {
  value = var.enable_module_output ? azurerm_role_assignment.role_assignment_application : null
}