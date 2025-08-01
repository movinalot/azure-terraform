resource "azurerm_storage_share" "storage_share" {
  for_each = {
    for name, user in local.user_resource_groups_map : name => user
    if user.storage == true
  }

  name               = local.user_common["storage_share_name"]
  quota              = local.user_common["storage_share_quota"]
  storage_account_id = azurerm_storage_account.storage_account[each.value.resource_group_name].id

}

output "storage_shares" {
  value = var.enable_output ? azurerm_storage_share.storage_share[*] : null
}
