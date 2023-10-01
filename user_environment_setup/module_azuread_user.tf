module "module_azuread_user" {
  for_each = local.users

  source = "git::https://github.com/movinalot/azure.git//ad/azuread_user"

  #source = "../azure/ad/azuread_user"

  user_principal_name = format("%s%s", each.value.name, local.user_common["user_principal_name_ext"])
  display_name        = format("%s%s", each.value.name, local.user_common["display_name_ext"])
  mail_nickname       = format("%s%s", each.value.name, local.user_common["display_name_ext"])
  mail                = format("%s%s", each.value.name, local.user_common["user_principal_name_ext"])
  password            = local.user_common["password"]
  account_enabled     = local.user_common["account_enabled"]
}

output "users" {
  value     = var.enable_module_output ? module.module_azuread_user[*] : null
  sensitive = true
}
