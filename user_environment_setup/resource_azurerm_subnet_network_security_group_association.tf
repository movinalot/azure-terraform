resource "azurerm_subnet_network_security_group_association" "subnet_network_security_group_association" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true
  } : {}

  subnet_id                 = azurerm_subnet.subnet[format("%s-%s-utility", each.value.username, each.value.suffix)].id
  network_security_group_id = azurerm_network_security_group.network_security_group[format("%s-%s", each.value.username, each.value.suffix)].id
}

output "subnet_network_security_group_associations" {
  value = var.enable_output ? azurerm_subnet_network_security_group_association.subnet_network_security_group_association[*] : null
}
