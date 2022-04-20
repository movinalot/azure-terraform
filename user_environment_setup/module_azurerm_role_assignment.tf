module "module_azurerm_role_assignment" {
  for_each = local.role_assignments

  source = "../azure/rm/azurerm_role_assignment"

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

output "role_assignments" {
  value = var.enable_module_output ? module.module_azurerm_role_assignment[*] : null
}
