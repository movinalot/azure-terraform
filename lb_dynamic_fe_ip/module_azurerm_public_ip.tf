locals {
  public_ips = {
    "pub_ip_1" = { name = "pub_ip_1", allocation_method = "Static", sku = "Standard" }
    "pub_ip_2" = { name = "pub_ip_2", allocation_method = "Static", sku = "Standard" }
    "pub_ip_3" = { name = "pub_ip_3", allocation_method = "Static", sku = "Standard" }
  }
}

module "module_azurerm_public_ip" {
  for_each = local.public_ips

  source = "../azure/rm/azurerm_public_ip"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name
  location            = module.module_azurerm_resource_group.resource_group.location
  name                = each.value.name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku

}

output "public_ips" {
  value = module.module_azurerm_public_ip[*]
}