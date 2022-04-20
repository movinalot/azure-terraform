module "module_azurerm_storage_share" {
  for_each = local.users

  source = "../azure/rm/azurerm_storage_share"

  name                 = local.user_common["storage_share_name"]
  quota                = local.user_common["storage_share_quota"]
  storage_account_name = module.module_azurerm_storage_account[each.value.name].storage_account.name
}

output "storage_shares" {
  value = var.enable_module_output ? module.module_azurerm_storage_share[*] : null
}
