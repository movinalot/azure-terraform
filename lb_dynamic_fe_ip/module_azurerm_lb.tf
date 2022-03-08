locals {
  lbs = {
    "external_lb_1" = {
      name                = "external_lb_1"
      sku                 = "standard"
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
      location            = module.module_azurerm_resource_group.resource_group.location
      frontend_ip_configurations = [
        {
          name                 = "external_lb_1_fe_ip_1"
          public_ip_address_id = module.module_azurerm_public_ip["pub_ip_1"].public_ip.id
        },
        {
          name                 = "external_lb_1_fe_ip_2"
          public_ip_address_id = module.module_azurerm_public_ip["pub_ip_2"].public_ip.id
        }
      ]
    },
    "external_lb_2" = {
      name                = "external_lb_2"
      sku                 = "standard"
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
      location            = module.module_azurerm_resource_group.resource_group.location
      frontend_ip_configurations = [
        {
          name                 = "external_lb_2_fe_ip_1"
          public_ip_address_id = module.module_azurerm_public_ip["pub_ip_3"].public_ip.id
        }
      ]
    },
    "internal_lb_1" = {
      name                = "internal_lb_1"
      sku                 = "standard"
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
      location            = module.module_azurerm_resource_group.resource_group.location
      frontend_ip_configurations = [
        {
          name                          = "internal_lb_1_fe_ip_1"
          subnet_id                     = module.module_azurerm_subnet["subnet_0"].subnet.id
          vnet_name                     = module.module_azurerm_virtual_network["vnet_1"].virtual_network.name
          private_ip_address            = cidrhost(module.module_azurerm_subnet["subnet_0"].subnet.address_prefix, 5)
          private_ip_address_allocation = "Static"
          private_ip_address_version    = "IPv4"
        }
      ]
    }
  }
}

module "module_azurerm_lb" {
  for_each = local.lbs

  source = "../azure/rm/azurerm_lb"

  resource_group_name        = var.resource_group_name
  location                   = var.resource_group_location
  name                       = each.value.name
  sku                        = each.value.sku
  frontend_ip_configurations = each.value.frontend_ip_configurations
}

output "lbs" {
  value = module.module_azurerm_lb[*]
}