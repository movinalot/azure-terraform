module "module_azurerm_storage_account" {
  for_each = local.users

  source = "../azure/rm/azurerm_storage_account"

  resource_group_name      = module.module_azurerm_resource_group[each.value.name].resource_group.name
  location                 = module.module_azurerm_resource_group[each.value.name].resource_group.location
  name                     = format("%s%s%s", local.user_common["storage_prefix"], each.value.name, random_id.id[each.value.name].hex)
  account_replication_type = local.user_common["storage_account_replication_type"]
  account_tier             = local.user_common["storage_account_tier"]
}

output "storage_accounts" {
  value     = var.enable_module_output ? module.module_azurerm_storage_account[*] : null
  sensitive = true
}