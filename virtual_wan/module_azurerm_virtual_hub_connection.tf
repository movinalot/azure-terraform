module "module_azurerm_virtual_hub_connection" {
  for_each = local.virtual_hub_connections

  source = "../azure/rm/azurerm_virtual_hub_connection"

  name                      = each.value.name
  virtual_hub_id            = each.value.virtual_hub_id
  remote_virtual_network_id = each.value.remote_virtual_network_id

}

output "virtual_hub_connection" {
  value = var.enable_module_output ? module.module_azurerm_virtual_hub_connection[*] : null
}
