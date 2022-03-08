locals {
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "module_azurerm_resource_group" {

  source = "../azure/rm/azurerm_resource_group"

  name     = local.resource_group_name
  location = local.resource_group_location
}

output "resource_group" {
  value = module.module_azurerm_resource_group
}