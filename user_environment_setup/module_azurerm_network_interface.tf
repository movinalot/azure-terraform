module "module_azurerm_network_interface" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_subnets_map : name => user
    if user.subnet_name == "utility"
  } : {}

  source = "git::https://github.com/movinalot/azure.git//rm/azurerm_network_interface"

  #source = "../azure/rm/azurerm_network_interface"

  resource_group_name = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.name
  location            = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.location

  name = format("nic_vm_%s_%s", each.value.username, each.value.suffix)

  enable_ip_forwarding          = false
  enable_accelerated_networking = false

  ip_configurations = [
    {
      name                          = "ipconfig1"
      primary                       = true
      subnet_id                     = module.module_azurerm_subnet[each.key].subnet.id
      private_ip_address_allocation = "Static"
      private_ip_address            = cidrhost(module.module_azurerm_subnet[each.key].subnet.address_prefixes[0], 4)
      public_ip_address_id          = try(module.module_azurerm_public_ip_service_access[each.value.resource_group_name].public_ip.id, false) != false ? module.module_azurerm_public_ip_service_access[each.value.resource_group_name].public_ip.id : null
    }
  ]
}

output "network_interfaces" {
  value = var.enable_module_output ? module.module_azurerm_network_interface[*] : null
}
