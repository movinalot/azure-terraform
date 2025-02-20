resource "azurerm_network_security_rule" "network_security_rule" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_nsgsr_map : name => user
    if user.bastion == true
  } : {}

  resource_group_name = each.value.resource_group_name

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  network_security_group_name = azurerm_network_security_group.network_security_group[each.value.resource_group_name].name
}

output "network_security_rules" {
  value = var.enable_output ? azurerm_network_security_rule.network_security_rule[*] : null
}