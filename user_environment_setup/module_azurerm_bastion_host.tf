
module "module_azurerm_bastion_host" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_subnets_map : name => user
    if user.subnet_name == "AzureBastionSubnet"
  } : {}

  source = "../azure/rm/azurerm_bastion_host"

  resource_group_name = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.name
  location            = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.location

  name                   = format("bastion_%s_%s_%s", each.value.bastion_host_type, each.value.username, each.value.suffix)
  sku                    = "Standard"
  shareable_link_enabled = true

  ip_configurations = [
    {
      name                 = "ipconfig1"
      subnet_id            = module.module_azurerm_subnet[each.key].subnet.id
      public_ip_address_id = module.module_azurerm_public_ip[each.value.resource_group_name].public_ip.id
    }
  ]
}

output "bastion_hosts" {
  value = var.enable_module_output ? module.module_azurerm_bastion_host[*] : null
}
