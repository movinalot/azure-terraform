module "module_azurerm_virtual_hub" {
  for_each = local.virtual_hubs

  source = "../azure/rm/azurerm_virtual_hub"

  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  name           = each.value.name
  virtual_wan_id = each.value.virtual_wan_id
  address_prefix = each.value.address_prefix

}

output "virtual_hub" {
  value = var.enable_module_output ? module.module_azurerm_virtual_hub[*] : null
}
