resource "azuread_group" "group" {
  for_each = local.groups

  display_name       = each.value.display_name
  owners             = each.value.owners
  security_enabled   = each.value.security_enabled
  assignable_to_role = each.value.assignable_to_role
}

output "groups" {
  value = var.enable_output ? azuread_group.group[*] : null
}
