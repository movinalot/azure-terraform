module "module_azuread_user" {
  for_each = var.users

  source = "../azure/ad/azuread_user"

  user_principal_name = format("%s%s", each.value.name, var.user_common["user_principal_name_ext"])
  display_name        = format("%s%s", each.value.name, var.user_common["display_name_ext"])
  mail_nickname       = format("%s%s", each.value.name, var.user_common["display_name_ext"])
  mail                = format("%s%s", each.value.name, var.user_common["user_principal_name_ext"])
  password            = var.user_common["password"]
  account_enabled     = var.user_common["account_enabled"]
}

output "users" {
  value     = module.module_azuread_user[*]
  sensitive = true
}
