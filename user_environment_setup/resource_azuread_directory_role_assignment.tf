resource "azuread_directory_role_assignment" "directory_role_assignment" {
  for_each = local.security_group_ad_role_support ? local.directory_role_assignments : {}

  role_id             = each.value.role_id
  principal_object_id = each.value.principal_object_id
}

output "directory_role_assignments" {
  value = var.enable_output ? azuread_directory_role_assignment.directory_role_assignment[*] : null
}
