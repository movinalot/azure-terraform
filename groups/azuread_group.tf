resource "azuread_group" "group" {
  count = local.group_count

  display_name       = format("%s%04d", local.group_prefix, count.index + local.group_start)
  owners             = null
  security_enabled   = true
  assignable_to_role = false
}

output "group" {
  value = azuread_group.group
}
