resource "azuread_user" "user" {
  for_each = local.users

  user_principal_name = format("%s%s", each.value.name, local.user_common["user_principal_name_ext"])
  display_name        = format("%s%s", each.value.name, local.user_common["display_name_ext"])
  mail_nickname       = format("%s%s", each.value.name, local.user_common["display_name_ext"])
  mail                = format("%s%s", each.value.name, local.user_common["user_principal_name_ext"])
  password            = local.user_common["password"]
  account_enabled     = local.user_common["account_enabled"]
}

output "users" {
  value     = var.enable_output ? azuread_user.user[*] : null
  sensitive = true
}
