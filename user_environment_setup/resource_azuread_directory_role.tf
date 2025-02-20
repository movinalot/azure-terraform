resource "azuread_directory_role" "directory_role" {
  for_each = local.security_group_ad_role_support ? local.directory_roles : {}

  display_name = each.value.display_name
}

output "directory_roles" {
  value = var.enable_output ? azuread_directory_role.directory_role[*] : null
}
