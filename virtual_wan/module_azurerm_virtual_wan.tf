module "module_azurerm_virtual_wan" {
  for_each = local.virtual_wans

  source = "../azure/rm/azurerm_virtual_wan"

  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  name = each.value.name
  type = each.value.type
}

output "virtual_wan" {
  value = var.enable_module_output ? module.module_azurerm_virtual_wan[*] : null
}
