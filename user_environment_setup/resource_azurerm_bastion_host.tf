
resource "azurerm_bastion_host" "bastion_host" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_subnets_map : name => user
    if user.subnet_name == "AzureBastionSubnet"
  } : {}

  resource_group_name = azurerm_resource_group.resource_group[each.value.resource_group_name].name
  location            = azurerm_resource_group.resource_group[each.value.resource_group_name].location

  name                   = format("bastion_%s_%s_%s", each.value.bastion_host_type, each.value.username, each.value.suffix)
  sku                    = "Standard"
  shareable_link_enabled = true

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = azurerm_subnet.subnet[each.key].id
    public_ip_address_id = azurerm_public_ip.public_ip[each.value.resource_group_name].id
  }
}

output "bastion_hosts" {
  value = var.enable_output ? azurerm_bastion_host.bastion_host[*] : null
}
