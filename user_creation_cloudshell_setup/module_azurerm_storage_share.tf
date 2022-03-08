module "module_azurerm_storage_share" {
  for_each = var.users

  source = "../azure/rm/azurerm_storage_share"

  name                 = var.user_common["share_name"]
  storage_account_name = module.module_azurerm_storage_account[each.value.name].storage_account.name
}

output "storage_shares" {
  value = module.module_azurerm_storage_share[*]
}
