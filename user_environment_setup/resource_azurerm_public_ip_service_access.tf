resource "azurerm_public_ip" "public_ip_service_access" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true
  } : {}

  resource_group_name = azurerm_resource_group.resource_group[each.value.resource_group_name].name
  location            = azurerm_resource_group.resource_group[each.value.resource_group_name].location

  name = format("pip_service_access_%s_%s", each.value.username, each.value.suffix)

  allocation_method = "Static"
  sku               = "Standard"

}

output "public_ips_service_access" {
  value = var.enable_output ? azurerm_public_ip.public_ip_service_access[*] : null
}
