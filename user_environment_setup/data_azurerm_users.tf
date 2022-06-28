data "azuread_users" "users" {
  for_each = local.group_owners

  user_principal_names = each.value.owners
}
