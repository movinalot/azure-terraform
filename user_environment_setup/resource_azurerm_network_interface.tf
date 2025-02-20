resource "azurerm_network_interface" "network_interface" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_subnets_map : name => user
    if user.subnet_name == "utility"
  } : {}

  resource_group_name = azurerm_resource_group.resource_group[each.value.resource_group_name].name
  location            = azurerm_resource_group.resource_group[each.value.resource_group_name].location

  name = format("nic_vm_%s_%s", each.value.username, each.value.suffix)

  ip_forwarding_enabled          = false
  accelerated_networking_enabled = false

  dynamic "ip_configuration" {

    for_each = each.value.ip_configurations
    content {
      #name                          = ip_configuration.value.name
      #primary                       = lookup(ip_configuration.value, "primary", false)
      name                          = "ipconfig1"
      primary                       = true
      subnet_id                     = azurerm_subnet.subnet[each.key].id
      private_ip_address_allocation = "Static"
      private_ip_address            = cidrhost(azurerm_subnet.subnet[each.key].address_prefixes[0], 4)
      public_ip_address_id          = try(azurerm_public_ip.public_ip_service_access[each.value.resource_group_name].id, false) != false ? azurerm_public_ip.public_ip_service_access[each.value.resource_group_name].id : null

    }
  }
}

output "network_interfaces" {
  value = var.enable_output ? azurerm_network_interface.network_interface[*] : null
}
