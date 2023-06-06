module "module_azurerm_subnet_network_security_group_association" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true
  } : {}

  source = "../azure/rm/azurerm_subnet_network_security_group_association"

  subnet_id                 = module.module_azurerm_subnet[format("%s-%s-utility", each.value.username, each.value.suffix)].subnet.id
  network_security_group_id = module.module_azurerm_network_security_group[format("%s-%s", each.value.username, each.value.suffix)].network_security_group.id
}

output "subnet_network_security_group_associations" {
  value = var.enable_module_output ? module.module_azurerm_subnet_network_security_group_association[*] : null
}
