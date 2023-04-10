locals {
  resource_groups = {
    "csa_vwan_1" = {
      name     = "csa_vwan_1"
      location = "eastus"
    }
    "csa_vwan_1_hub_eastus" = {
      name     = "csa_vwan_1_hub_eastus"
      location = "eastus"
    }
    "csa_vwan_1_hub_westus" = {
      name     = "csa_vwan_1_hub_westus"
      location = "westus"
    }
  }

  virtual_wans = {
    "vwan_1" = {
      resource_group_name = module.module_azurerm_resource_group["csa_vwan_1"].resource_group.name
      location            = module.module_azurerm_resource_group["csa_vwan_1"].resource_group.location

      name = "vwan_1"
      type = "Standard"
    }
  }

  virtual_hub_address_prefix = "10.0.0.0/16"

  virtual_hubs = {
    "hub_eastus" = {
      resource_group_name = module.module_azurerm_resource_group["csa_vwan_1_hub_eastus"].resource_group.name
      location            = module.module_azurerm_resource_group["csa_vwan_1_hub_eastus"].resource_group.location

      name           = "hub_eastus"
      sku            = "Standard"
      virtual_wan_id = module.module_azurerm_virtual_wan["vwan_1"].virtual_wan.id
      address_prefix = cidrsubnet(local.virtual_hub_address_prefix, 7, 0)
    }
    "hub_westus" = {
      resource_group_name = module.module_azurerm_resource_group["csa_vwan_1_hub_westus"].resource_group.name
      location            = module.module_azurerm_resource_group["csa_vwan_1_hub_westus"].resource_group.location

      name           = "hub_westus"
      sku            = "Standard"
      virtual_wan_id = module.module_azurerm_virtual_wan["vwan_1"].virtual_wan.id
      address_prefix = cidrsubnet(local.virtual_hub_address_prefix, 7, 1)
    }
  }

  virtual_networks = {
    "vnet_1_eastus" = {
      resource_group_name = module.module_azurerm_resource_group["csa_vwan_1_hub_eastus"].resource_group.name
      location            = module.module_azurerm_resource_group["csa_vwan_1_hub_eastus"].resource_group.location

      name          = "vnet_1_eastus"
      address_space = ["10.125.0.0/16"]
    }
    "vnet_2_eastus" = {
      resource_group_name = module.module_azurerm_resource_group["csa_vwan_1_hub_eastus"].resource_group.name
      location            = module.module_azurerm_resource_group["csa_vwan_1_hub_eastus"].resource_group.location

      name          = "vnet_2_eastus"
      address_space = ["10.126.0.0/16"]
    }
    "vnet_3_eastus" = {
      resource_group_name = module.module_azurerm_resource_group["csa_vwan_1_hub_eastus"].resource_group.name
      location            = module.module_azurerm_resource_group["csa_vwan_1_hub_eastus"].resource_group.location

      name          = "vnet_3_eastus"
      address_space = ["10.127.0.0/16"]
    }
    "vnet_1_westus" = {
      resource_group_name = module.module_azurerm_resource_group["csa_vwan_1_hub_westus"].resource_group.name
      location            = module.module_azurerm_resource_group["csa_vwan_1_hub_westus"].resource_group.location

      name          = "vnet_1_westus"
      address_space = ["10.225.0.0/16"]
    }
    "vnet_2_westus" = {
      resource_group_name = module.module_azurerm_resource_group["csa_vwan_1_hub_westus"].resource_group.name
      location            = module.module_azurerm_resource_group["csa_vwan_1_hub_westus"].resource_group.location

      name          = "vnet_2_westus"
      address_space = ["10.226.0.0/16"]
    }
    "vnet_3_westus" = {
      resource_group_name = module.module_azurerm_resource_group["csa_vwan_1_hub_westus"].resource_group.name
      location            = module.module_azurerm_resource_group["csa_vwan_1_hub_westus"].resource_group.location

      name          = "vnet_3_westus"
      address_space = ["10.227.0.0/16"]
    }
  }

  virtual_hub_connections = {
    "vnet_1_eastus_connection" = {
      name                      = "vnet_1_eastus_connection"
      virtual_hub_id            = module.module_azurerm_virtual_hub["hub_eastus"].virtual_hub.id
      remote_virtual_network_id = module.module_azurerm_virtual_network["vnet_1_eastus"].virtual_network.id
    }
    "vnet_2_eastus_connection" = {
      name                      = "vnet_2_eastus_connection"
      virtual_hub_id            = module.module_azurerm_virtual_hub["hub_eastus"].virtual_hub.id
      remote_virtual_network_id = module.module_azurerm_virtual_network["vnet_2_eastus"].virtual_network.id
    }
    "vnet_3_eastus_connection" = {
      name                      = "vnet_3_eastus_connection"
      virtual_hub_id            = module.module_azurerm_virtual_hub["hub_eastus"].virtual_hub.id
      remote_virtual_network_id = module.module_azurerm_virtual_network["vnet_3_eastus"].virtual_network.id
    }
    "vnet_1_westus_connection" = {
      name                      = "vnet_1_westus_connection"
      virtual_hub_id            = module.module_azurerm_virtual_hub["hub_westus"].virtual_hub.id
      remote_virtual_network_id = module.module_azurerm_virtual_network["vnet_1_westus"].virtual_network.id
    }
    "vnet_2_westus_connection" = {
      name                      = "vnet_2_westus_connection"
      virtual_hub_id            = module.module_azurerm_virtual_hub["hub_westus"].virtual_hub.id
      remote_virtual_network_id = module.module_azurerm_virtual_network["vnet_2_westus"].virtual_network.id
    }
    "vnet_3_westus_connection" = {
      name                      = "vnet_3_westus_connection"
      virtual_hub_id            = module.module_azurerm_virtual_hub["hub_westus"].virtual_hub.id
      remote_virtual_network_id = module.module_azurerm_virtual_network["vnet_3_westus"].virtual_network.id
    }
  }

  subnets = {

  }
}
