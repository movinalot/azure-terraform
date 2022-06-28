module "module_azuread_directory_role_assignment" {
  for_each = local.directory_role_assignments

  source = "../azure/ad/azuread_directory_role_assignment"

  role_id             = each.value.role_id
  principal_object_id = each.value.principal_object_id
}

output "directory_role_assignmentss" {
  value = var.enable_module_output ? module.module_azuread_directory_role_assignment[*] : null
}
