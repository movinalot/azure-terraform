module "module_azurerm_storage_account" {
  for_each = {
    for name, user in local.user_resource_groups_map : name => user
    if user.storage == true
  }

  source = "../azure/rm/azurerm_storage_account"

  resource_group_name      = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.name
  location                 = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.location
  name                     = length(format("%s%s%s", each.value.username, random_id.id[each.value.username].hex, each.value.suffix)) > 24 ? substr(format("%s%s%s", each.value.username, random_id.id[each.value.username].hex, each.value.suffix), 0, 24) : format("%s%s%s", each.value.username, random_id.id[each.value.username].hex, each.value.suffix)
  account_replication_type = local.user_common["storage_account_replication_type"]
  account_tier             = local.user_common["storage_account_tier"]
}

output "storage_accounts" {
  value     = var.enable_module_output ? module.module_azurerm_storage_account[*] : null
  sensitive = true
}