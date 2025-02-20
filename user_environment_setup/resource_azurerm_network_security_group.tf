resource "azurerm_network_security_group" "network_security_group" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true
  } : {}

  resource_group_name = azurerm_resource_group.resource_group[each.value.resource_group_name].name
  location            = azurerm_resource_group.resource_group[each.value.resource_group_name].location

  name = format("nsg-%s-%s", each.value.username, each.value.suffix)
}

output "network_security_groups" {
  value = var.enable_output ? azurerm_network_security_group.network_security_group[*] : null
}
