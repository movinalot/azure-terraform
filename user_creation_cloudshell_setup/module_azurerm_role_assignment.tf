data "azurerm_subscription" "subscription" {
}

module "module_azurerm_role_assignment" {
  for_each = var.subscription_role_assignments

  source = "../azure/rm/azurerm_role_assignment"

  scope                = data.azurerm_subscription.subscription.id
  role_definition_name = each.value.role_definition_name
  principal_id         = module.module_azuread_group[each.value.group_display_name].group.id
}

output "role_assignments" {
  value = module.module_azurerm_role_assignment[*]
}
