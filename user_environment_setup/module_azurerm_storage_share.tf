module "module_azurerm_storage_share" {
  for_each = {
    for name, user in local.user_resource_groups_map : name => user
    if user.storage == true
  }

  source = "git::https://github.com/movinalot/azure.git//rm/azurerm_storage_share"

  #source = "../azure/rm/azurerm_storage_share"

  name                 = local.user_common["storage_share_name"]
  quota                = local.user_common["storage_share_quota"]
  storage_account_name = module.module_azurerm_storage_account[each.value.resource_group_name].storage_account.name
}

output "storage_shares" {
  value = var.enable_module_output ? module.module_azurerm_storage_share[*] : null
}
