locals {
  resource_groups = {
    (var.resource_group_name) = {
      name     = var.resource_group_name
      location = var.resource_group_location
    }
  }

  public_ips = {
    "pip_lbe_1_fe_1" = {
      resource_group_name = azurerm_resource_group.resource_group[var.resource_group_name].name
      location            = azurerm_resource_group.resource_group[var.resource_group_name].location

      name              = "pip_lbe_1_fe_1"
      allocation_method = "Static"
      sku               = "Standard"
    }
    "pip_lbe_1_fe_2" = {
      resource_group_name = azurerm_resource_group.resource_group[var.resource_group_name].name
      location            = azurerm_resource_group.resource_group[var.resource_group_name].location

      name              = "pip_lbe_1_fe_2"
      allocation_method = "Static"
      sku               = "Standard"
    }
    "pip_lbe_2_fe_1" = {
      resource_group_name = azurerm_resource_group.resource_group[var.resource_group_name].name
      location            = azurerm_resource_group.resource_group[var.resource_group_name].location

      name              = "pip_lbe_2_fe_1"
      allocation_method = "Static"
      sku               = "Standard"
    }
  }

  virtual_networks = {
    (var.virtual_network_name) = {
      resource_group_name = azurerm_resource_group.resource_group[var.resource_group_name].name
      location            = azurerm_resource_group.resource_group[var.resource_group_name].location

      name          = var.virtual_network_name
      address_space = var.virtual_network_address_space
    }
  }

  subnets = {
    "snet_0" = {
      resource_group_name = azurerm_resource_group.resource_group[var.resource_group_name].name

      name             = "snet_0"
      vnet_name        = azurerm_virtual_network.virtual_network[var.virtual_network_name].name
      address_prefixes = [cidrsubnet(tolist(azurerm_virtual_network.virtual_network[var.virtual_network_name].address_space)[0], 8, 0)]
    }
    "snet_1" = {
      resource_group_name = azurerm_resource_group.resource_group[var.resource_group_name].name

      name             = "snet_1"
      vnet_name        = azurerm_virtual_network.virtual_network[var.virtual_network_name].name
      address_prefixes = [cidrsubnet(tolist(azurerm_virtual_network.virtual_network[var.virtual_network_name].address_space)[0], 8, 1)]
    }

    "snet_2" = {
      resource_group_name = azurerm_resource_group.resource_group[var.resource_group_name].name

      name             = "snet_2"
      vnet_name        = azurerm_virtual_network.virtual_network[var.virtual_network_name].name
      address_prefixes = [cidrsubnet(tolist(azurerm_virtual_network.virtual_network[var.virtual_network_name].address_space)[0], 8, 2)]
    }
    "snet_3" = {
      resource_group_name = azurerm_resource_group.resource_group[var.resource_group_name].name

      name             = "snet_3"
      vnet_name        = azurerm_virtual_network.virtual_network[var.virtual_network_name].name
      address_prefixes = [cidrsubnet(tolist(azurerm_virtual_network.virtual_network[var.virtual_network_name].address_space)[0], 8, 3)]
    }
  }

  lbs = {
    "lbe_1" = {
      resource_group_name = azurerm_resource_group.resource_group[var.resource_group_name].name
      location            = azurerm_resource_group.resource_group[var.resource_group_name].location

      name = "lbe_1"
      sku  = "Standard"
      frontend_ip_configurations = [
        {
          name                 = "lbe_1_fe_1"
          public_ip_address_id = azurerm_public_ip.public_ip["pip_lbe_1_fe_1"].id
        },
        {
          name                 = "lbe_1_fe_2"
          public_ip_address_id = azurerm_public_ip.public_ip["pip_lbe_1_fe_2"].id
        }
      ]
    },
    "lbe_2" = {
      resource_group_name = azurerm_resource_group.resource_group[var.resource_group_name].name
      location            = azurerm_resource_group.resource_group[var.resource_group_name].location

      name = "lbe_2"
      sku  = "Standard"
      frontend_ip_configurations = [
        {
          name                 = "lbe_2_fe_1"
          public_ip_address_id = azurerm_public_ip.public_ip["pip_lbe_2_fe_1"].id
        }
      ]
    },
    "lbi_1" = {
      resource_group_name = azurerm_resource_group.resource_group[var.resource_group_name].name
      location            = azurerm_resource_group.resource_group[var.resource_group_name].location

      name = "lbi_1"
      sku  = "Standard"
      frontend_ip_configurations = [
        {
          name                          = "internal_lb_1_fe_ip_1"
          subnet_id                     = azurerm_subnet.subnet["snet_0"].id
          vnet_name                     = azurerm_virtual_network.virtual_network[var.virtual_network_name].name
          private_ip_address            = cidrhost(azurerm_subnet.subnet["snet_0"].address_prefixes[0], 5)
          private_ip_address_allocation = "Static"
          private_ip_address_version    = "IPv4"
        }
      ]
    }
  }
}