resource "azurerm_storage_account" "storage_account" {
  for_each = {
    for name, user in local.user_resource_groups_map : name => user
    if user.storage == true
  }

  resource_group_name = azurerm_resource_group.resource_group[each.value.resource_group_name].name
  location            = azurerm_resource_group.resource_group[each.value.resource_group_name].location

  name                     = length(replace(format("%s%s%s", each.value.username, random_id.id[each.value.username].hex, each.value.suffix), "/-*_*/", "")) > 24 ? substr(replace(format("%s%s%s", each.value.username, random_id.id[each.value.username].hex, each.value.suffix), "/-*_*/", ""), 0, 24) : replace(format("%s%s%s", each.value.username, random_id.id[each.value.username].hex, each.value.suffix), "/-*_*/", "")
  account_replication_type = local.user_common["storage_account_replication_type"]
  account_tier             = local.user_common["storage_account_tier"]
}

output "storage_accounts" {
  value     = var.enable_output ? azurerm_storage_account.storage_account[*] : null
  sensitive = true
}
