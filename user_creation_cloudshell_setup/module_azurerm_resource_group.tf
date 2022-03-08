module "module_azurerm_resource_group" {
  for_each = var.users

  source = "../azure/rm/azurerm_resource_group"

  name     = format("%s%s", each.value.name, var.user_common["display_name_ext"])
  location = each.value.location
}

output "resource_groups" {
  value = module.module_azurerm_resource_group[*]
}
