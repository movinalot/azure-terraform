resource "azurerm_role_assignment" "role_assignment" {
  for_each = local.user_resource_group_roles_map

  scope                = azurerm_resource_group.resource_group[each.value.resource_group_name].id
  role_definition_name = each.value.role_definition_name
  principal_id         = azuread_user.user[each.value.username].object_id
}

output "role_assignments" {
  value = var.enable_output ? azurerm_role_assignment.role_assignment[*] : null
}

output "user_resource_group_roles_list" {
  value = var.enable_output ? local.user_resource_group_roles_list : null
}

output "user_resource_group_roles_map" {
  value = var.enable_output ? local.user_resource_group_roles_map : null
}

resource "azurerm_role_assignment" "group_role_assignment" {
  for_each = local.group_roles

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}