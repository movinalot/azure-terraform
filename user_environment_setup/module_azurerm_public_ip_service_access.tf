module "module_azurerm_public_ip_service_access" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true
  } : {}

  source = "../azure/rm/azurerm_public_ip"

  resource_group_name = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.name
  location            = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.location

  name = format("pip_service_access_%s_%s", each.value.username, each.value.suffix)

  allocation_method = "Static"
  sku               = "Standard"
}

output "public_ips_service_access" {
  value = var.enable_module_output ? module.module_azurerm_public_ip_service_access[*] : null
}