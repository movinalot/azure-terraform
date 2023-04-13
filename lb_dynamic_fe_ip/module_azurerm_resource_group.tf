module "module_azurerm_resource_group" {
  for_each = local.resource_groups

  source = "git::https://github.com/movinalot/azure.git//rm/azurerm_resource_group"

  name     = each.value.name
  location = each.value.location
}

output "resource_groups" {
  value = var.enable_module_output ? module.module_azurerm_resource_group[*] : null
}
