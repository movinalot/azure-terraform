data "azuread_users" "users" {
  for_each = var.group_owners

  user_principal_names = each.value.owners
}
