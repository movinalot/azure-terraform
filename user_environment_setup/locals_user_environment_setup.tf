locals {

  user_prefix = var.user_prefix

  # Should a Bastion host be created per user
  bastion_host_support = false

  # Should the Bastion host virtual network be the same address space for each user or sequential 
  sequential_vnet_address_space = false

  # Should a Service Principal be created per user
  per_user_service_principal      = false
  per_user_service_principal_role = "Owner"

  # Training Group name
  training_group_name = "${local.user_prefix}-training-group"

  # Azure P1 false, P2 true
  security_group_ad_role_support = false

  # Entra ID roles assigned to the Training Group members (the user accounts) 
  directory_roles = {
    "Application Administrator" = {
      display_name = "Application Administrator"
    }
    "Global Reader" = {
      display_name = "Global Reader"
    }
  }

  # Entra ID roles Group association
  directory_role_assignments = {
    "Application Administrator" = {
      role_id             = local.security_group_ad_role_support ? azuread_directory_role.directory_role["Application Administrator"].object_id : ""
      principal_object_id = local.security_group_ad_role_support ? azuread_group.group[local.training_group_name].object_id : ""
    }
    "Global Reader" = {
      role_id             = local.security_group_ad_role_support ? azuread_directory_role.directory_role["Global Reader"].object_id : ""
      principal_object_id = local.security_group_ad_role_support ? azuread_group.group[local.training_group_name].object_id : ""
    }
  }

  groups = {
    (local.training_group_name) = {
      display_name       = local.training_group_name
      owners             = data.azuread_users.users[local.training_group_name].object_ids
      security_enabled   = true
      assignable_to_role = local.security_group_ad_role_support
    }
  }

  group_owners = {
    (local.training_group_name) = {
      owners = var.training_group_owners
    }
  }

  # Resource Groups will be "username-resource_group_suffix" in specified location
  # Set storage to true to create a Storage Account in the Resource Group
  #   Storage Account will be named <username><randomid><resource_group_suffix>
  #    up to 24 characters, "-" and "_" removed
  # Set bastion to true to create a bastion host
  resource_groups = [
    {
      suffix            = "training"
      location          = "eastus"
      storage           = false
      bastion           = false
      bastion_host_type = "win"
    },

    # Add additional per user Resource Groups
    # {
    #   suffix   = "fortigate"
    #   location = "eastus"
    #   storage  = false
    #   bastion  = false
    #   bastion_host_type = ""

    # },
    # {
    #   suffix   = "fortiweb"
    #   location = "eastus"
    #   storage  = false
    #   bastion  = false
    #   bastion_host_type = ""

    # }
  ]

  # Create a list of User and Resource Group Sets
  user_resource_groups_list = setproduct(values(local.users), local.resource_groups)

  # Create a map of User and Resource Group Sets from the list
  user_resource_groups_map = {
    for item in local.user_resource_groups_list :
    format("%s-%s", item[0]["name"], item[1]["suffix"]) => {
      username                   = item[0]["name"],
      resource_group_name        = format("%s-%s", item[0]["name"], item[1]["suffix"]),
      suffix                     = item[1]["suffix"],
      location                   = item[1]["location"],
      storage                    = item[1]["storage"],
      bastion                    = item[1]["bastion"],
      bastion_host_type          = item[1]["bastion_host_type"],
      utility_vnet_address_space = local.sequential_vnet_address_space ? [format("192.168.%s.0/24", trim(item[0]["name"], var.user_prefix))] : ["192.168.100.0/24"]
    }
  }

  # Subnets for Bastion and utility hosts, name and Address Prefixes required
  subnet_names = [["AzureBastionSubnet", "128/25"], ["utility", "0/25"]]

  # Create a list of User, Resource Group, and Subnet Sets
  user_resource_group_subnets_list = setproduct(values(local.user_resource_groups_map), local.subnet_names)

  user_resource_groups_subnets_map = {
    for item in local.user_resource_group_subnets_list :
    format("%s-%s", item[0]["resource_group_name"], item[1][0]) => {
      username                = item[0]["username"],
      resource_group_name     = format("%s-%s", item[0]["username"], item[0]["suffix"]),
      suffix                  = item[0]["suffix"],
      location                = item[0]["location"],
      storage                 = item[0]["storage"],
      bastion                 = item[0]["bastion"],
      bastion_host_type       = item[0]["bastion_host_type"],
      subnet_name             = item[1][0],
      subnet_address_prefixes = local.sequential_vnet_address_space ? [format("192.168.%s.%s", trim(item[0]["username"], var.user_prefix), item[1][1])] : [format("192.168.100.%s", item[1][1])]
    } if item[0]["bastion"] == true
  }

  # User roles that will be assigned to the user's Resource Group
  role_definition_names = ["Contributor", "User Access Administrator"]

  # Create a list of User, Resource Group, and Role Sets
  user_resource_group_roles_list = setproduct(values(local.user_resource_groups_map), local.role_definition_names)

  # Create a map of User, Resource Group, and Role Sets from the list
  user_resource_group_roles_map = {
    for item in local.user_resource_group_roles_list :
    format("%s-%s", item[0]["resource_group_name"], item[1]) => {
      resource_group_name  = item[0]["resource_group_name"],
      role_definition_name = item[1],
      username             = item[0]["username"]
    }
  }

  # nsg rules
  nsg_rules = [
    ["nsgsr-http", "1010", "Inbound", "Allow", "Tcp", "*", "80", "*", "*"],
    ["nsgsr-https", "1020", "Inbound", "Allow", "Tcp", "*", "443", "*", "*"],
    ["nsgsr-rdp", "1000", "Inbound", "Allow", "Tcp", "*", "3389", "*", "*"],
    ["nsgsr-ssh", "1030", "Inbound", "Allow", "Tcp", "*", "22", "*", "*"],
    ["nsgsr-winrm", "1040", "Inbound", "Allow", "Tcp", "*", "5985", "*", "*"],
    ["nsgsr-winrms", "1050", "Inbound", "Allow", "Tcp", "*", "5986", "*", "*"],
    ["nsgsr-allout", "1000", "Outbound", "Allow", "*", "*", "*", "*", "*"]
  ]

  # Create a list of User, Resource Group, and Subnet Sets
  user_resource_group_nsgsr_list = setproduct(values(local.user_resource_groups_map), local.nsg_rules)

  user_resource_groups_nsgsr_map = {
    for item in local.user_resource_group_nsgsr_list :
    format("%s-%s", item[0]["resource_group_name"], item[1][0]) => {
      username                   = item[0]["username"],
      resource_group_name        = format("%s-%s", item[0]["username"], item[0]["suffix"]),
      suffix                     = item[0]["suffix"],
      location                   = item[0]["location"],
      storage                    = item[0]["storage"],
      bastion                    = item[0]["bastion"],
      bastion_host_type          = item[0]["bastion_host_type"],
      name                       = item[1][0],
      priority                   = item[1][1],
      direction                  = item[1][2],
      access                     = item[1][3],
      protocol                   = item[1][4],
      source_port_range          = item[1][5],
      destination_port_range     = item[1][6],
      source_address_prefix      = item[1][7],
      destination_address_prefix = item[1][8]
    } if item[0]["bastion"] == true
  }

  # Create a list and then a map of Users
  user_list = setproduct([var.user_prefix], tolist(range(var.user_start, var.user_start + var.user_count)))

  users = {
    for item in local.user_list :
    format("%s%s", item[0], item[1]) => {
      name               = format("%s%s", item[0], item[1]),
      group_display_name = local.training_group_name
    }
  }

  # Common User attributes
  user_common = {
    user_principal_name_ext          = var.user_principal_name_ext
    display_name_ext                 = ""
    password                         = var.user_password
    account_enabled                  = true
    storage_share_name               = "cloudshell"
    storage_share_quota              = 50
    storage_account_tier             = "Standard"
    storage_account_replication_type = "LRS"

    utility_vnet_name = "vnet_utility"

    linux_vm_size   = "Standard_D2s_v4"
    windows_vm_size = "Standard_D2s_v4"
  }
}
