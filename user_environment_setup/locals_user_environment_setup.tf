locals {

  userprefix = "user"

  bastion_host_support = true

  per_user_service_principal      = true
  per_user_service_principal_role = "Owner"

  # Training Group name
  training_group_name = "${local.userprefix}-training-group"

  # Azure P1 false, P2 true
  security_group_ad_role_support = false

  # AD level roles assigned to the Training Group members (the user accounts) 
  directory_roles = {
    "Application Administrator" = {
      display_name = "Application Administrator"
    }
    "Global Reader" = {
      display_name = "Global Reader"
    }
  }

  # AD level roles Group association
  directory_role_assignments = {
    "Application Administrator" = {
      role_id             = local.security_group_ad_role_support ? module.module_azuread_directory_role["Application Administrator"].directory_role.object_id : ""
      principal_object_id = local.security_group_ad_role_support ? module.module_azuread_group[local.training_group_name].group.object_id : ""
    }
    "Global Reader" = {
      role_id             = local.security_group_ad_role_support ? module.module_azuread_directory_role["Global Reader"].directory_role.object_id : ""
      principal_object_id = local.security_group_ad_role_support ? module.module_azuread_group[local.training_group_name].group.object_id : ""
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
      storage           = true
      bastion           = true
      bastion_host_type = "win"
    },

    # Add additonal per user Resource Groups
    # {
    #   suffix   = "fortigate"
    #   location = "eastus"
    #   storage  = false
    #   bastion  = true
    #   bastion_host_type = "lin"

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
      username            = item[0]["name"],
      resource_group_name = format("%s-%s", item[0]["name"], item[1]["suffix"]),
      suffix              = item[1]["suffix"],
      location            = item[1]["location"],
      storage             = item[1]["storage"],
      bastion             = item[1]["bastion"],
      bastion_host_type   = item[1]["bastion_host_type"]
    }
  }

  # Subnets for Bastion and utility hosts, name and Adress Prefixes required
  subnet_names = [["AzureBastionSubnet", ["192.168.100.0/26"]], ["utility", ["192.168.100.64/26"]]]

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
      subnet_address_prefixes = item[1][1]
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

    utility_vnet_name          = "vnet_utility"
    utility_vnet_address_space = ["192.168.100.0/24"]

    linux_vm_size   = "Standard_D2s_v4"
    windows_vm_size = "Standard_D2s_v4"
  }

  users = {
    # "${local.userprefix}01" = { name = "${local.userprefix}01", group_display_name = local.training_group_name }
    # "${local.userprefix}02" = { name = "${local.userprefix}02", group_display_name = local.training_group_name }
    # "${local.userprefix}03" = { name = "${local.userprefix}03", group_display_name = local.training_group_name }
    # "${local.userprefix}04" = { name = "${local.userprefix}04", group_display_name = local.training_group_name }
    # "${local.userprefix}05" = { name = "${local.userprefix}05", group_display_name = local.training_group_name }
    # "${local.userprefix}06" = { name = "${local.userprefix}06", group_display_name = local.training_group_name }
    # "${local.userprefix}07" = { name = "${local.userprefix}07", group_display_name = local.training_group_name }
    # "${local.userprefix}08" = { name = "${local.userprefix}08", group_display_name = local.training_group_name }
    # "${local.userprefix}09" = { name = "${local.userprefix}09", group_display_name = local.training_group_name }
    # "${local.userprefix}10" = { name = "${local.userprefix}10", group_display_name = local.training_group_name }
    # "${local.userprefix}11" = { name = "${local.userprefix}11", group_display_name = local.training_group_name }
    # "${local.userprefix}12" = { name = "${local.userprefix}12", group_display_name = local.training_group_name }
    # "${local.userprefix}13" = { name = "${local.userprefix}13", group_display_name = local.training_group_name }
    # "${local.userprefix}14" = { name = "${local.userprefix}14", group_display_name = local.training_group_name }
    # "${local.userprefix}15" = { name = "${local.userprefix}15", group_display_name = local.training_group_name }
    # "${local.userprefix}16" = { name = "${local.userprefix}16", group_display_name = local.training_group_name }
    # "${local.userprefix}17" = { name = "${local.userprefix}17", group_display_name = local.training_group_name }
    # "${local.userprefix}18" = { name = "${local.userprefix}18", group_display_name = local.training_group_name }
    # "${local.userprefix}19" = { name = "${local.userprefix}19", group_display_name = local.training_group_name }
    # "${local.userprefix}20" = { name = "${local.userprefix}20", group_display_name = local.training_group_name }
    # "${local.userprefix}21" = { name = "${local.userprefix}21", group_display_name = local.training_group_name }
    # "${local.userprefix}22" = { name = "${local.userprefix}22", group_display_name = local.training_group_name }
    # "${local.userprefix}23" = { name = "${local.userprefix}23", group_display_name = local.training_group_name }
    # "${local.userprefix}24" = { name = "${local.userprefix}24", group_display_name = local.training_group_name }
    # "${local.userprefix}25" = { name = "${local.userprefix}25", group_display_name = local.training_group_name }
    # "${local.userprefix}26" = { name = "${local.userprefix}26", group_display_name = local.training_group_name }
    # "${local.userprefix}27" = { name = "${local.userprefix}27", group_display_name = local.training_group_name }
    # "${local.userprefix}28" = { name = "${local.userprefix}28", group_display_name = local.training_group_name }
    # "${local.userprefix}29" = { name = "${local.userprefix}29", group_display_name = local.training_group_name }
    # "${local.userprefix}30" = { name = "${local.userprefix}30", group_display_name = local.training_group_name }
    # "${local.userprefix}31" = { name = "${local.userprefix}31", group_display_name = local.training_group_name }
    # "${local.userprefix}32" = { name = "${local.userprefix}32", group_display_name = local.training_group_name }
    # "${local.userprefix}33" = { name = "${local.userprefix}33", group_display_name = local.training_group_name }
    # "${local.userprefix}34" = { name = "${local.userprefix}34", group_display_name = local.training_group_name }
    # "${local.userprefix}35" = { name = "${local.userprefix}35", group_display_name = local.training_group_name }
    # "${local.userprefix}36" = { name = "${local.userprefix}36", group_display_name = local.training_group_name }
    # "${local.userprefix}37" = { name = "${local.userprefix}37", group_display_name = local.training_group_name }
    # "${local.userprefix}38" = { name = "${local.userprefix}38", group_display_name = local.training_group_name }
    # "${local.userprefix}39" = { name = "${local.userprefix}39", group_display_name = local.training_group_name }
    # "${local.userprefix}40" = { name = "${local.userprefix}40", group_display_name = local.training_group_name }
    # "${local.userprefix}41" = { name = "${local.userprefix}41", group_display_name = local.training_group_name }
    # "${local.userprefix}42" = { name = "${local.userprefix}42", group_display_name = local.training_group_name }
    # "${local.userprefix}43" = { name = "${local.userprefix}43", group_display_name = local.training_group_name }
    # "${local.userprefix}44" = { name = "${local.userprefix}44", group_display_name = local.training_group_name }
    # "${local.userprefix}45" = { name = "${local.userprefix}45", group_display_name = local.training_group_name }
    # "${local.userprefix}46" = { name = "${local.userprefix}46", group_display_name = local.training_group_name }
    # "${local.userprefix}47" = { name = "${local.userprefix}47", group_display_name = local.training_group_name }
    # "${local.userprefix}48" = { name = "${local.userprefix}48", group_display_name = local.training_group_name }
    # "${local.userprefix}49" = { name = "${local.userprefix}49", group_display_name = local.training_group_name }
    # "${local.userprefix}50" = { name = "${local.userprefix}50", group_display_name = local.training_group_name }
    # "${local.userprefix}51" = { name = "${local.userprefix}51", group_display_name = local.training_group_name }
    # "${local.userprefix}52" = { name = "${local.userprefix}52", group_display_name = local.training_group_name }
    # "${local.userprefix}53" = { name = "${local.userprefix}53", group_display_name = local.training_group_name }
    # "${local.userprefix}54" = { name = "${local.userprefix}54", group_display_name = local.training_group_name }
    # "${local.userprefix}55" = { name = "${local.userprefix}55", group_display_name = local.training_group_name }
    # "${local.userprefix}56" = { name = "${local.userprefix}56", group_display_name = local.training_group_name }
    # "${local.userprefix}57" = { name = "${local.userprefix}57", group_display_name = local.training_group_name }
    # "${local.userprefix}58" = { name = "${local.userprefix}58", group_display_name = local.training_group_name }
    # "${local.userprefix}59" = { name = "${local.userprefix}59", group_display_name = local.training_group_name }
    # "${local.userprefix}60" = { name = "${local.userprefix}60", group_display_name = local.training_group_name }
    # "${local.userprefix}61" = { name = "${local.userprefix}61", group_display_name = local.training_group_name }
    # "${local.userprefix}62" = { name = "${local.userprefix}62", group_display_name = local.training_group_name }
    # "${local.userprefix}63" = { name = "${local.userprefix}63", group_display_name = local.training_group_name }
    # "${local.userprefix}64" = { name = "${local.userprefix}64", group_display_name = local.training_group_name }
    # "${local.userprefix}65" = { name = "${local.userprefix}65", group_display_name = local.training_group_name }
    # "${local.userprefix}66" = { name = "${local.userprefix}66", group_display_name = local.training_group_name }
    # "${local.userprefix}67" = { name = "${local.userprefix}67", group_display_name = local.training_group_name }
    # "${local.userprefix}68" = { name = "${local.userprefix}68", group_display_name = local.training_group_name }
    # "${local.userprefix}69" = { name = "${local.userprefix}69", group_display_name = local.training_group_name }
    # "${local.userprefix}70" = { name = "${local.userprefix}70", group_display_name = local.training_group_name }
    # "${local.userprefix}71" = { name = "${local.userprefix}71", group_display_name = local.training_group_name }
    # "${local.userprefix}72" = { name = "${local.userprefix}72", group_display_name = local.training_group_name }
    # "${local.userprefix}73" = { name = "${local.userprefix}73", group_display_name = local.training_group_name }
    # "${local.userprefix}74" = { name = "${local.userprefix}74", group_display_name = local.training_group_name }
    # "${local.userprefix}75" = { name = "${local.userprefix}75", group_display_name = local.training_group_name }
    # "${local.userprefix}76" = { name = "${local.userprefix}76", group_display_name = local.training_group_name }
    # "${local.userprefix}77" = { name = "${local.userprefix}77", group_display_name = local.training_group_name }
    # "${local.userprefix}78" = { name = "${local.userprefix}78", group_display_name = local.training_group_name }
    # "${local.userprefix}79" = { name = "${local.userprefix}79", group_display_name = local.training_group_name }
    # "${local.userprefix}80" = { name = "${local.userprefix}80", group_display_name = local.training_group_name }
    # "${local.userprefix}81" = { name = "${local.userprefix}81", group_display_name = local.training_group_name }
    # "${local.userprefix}82" = { name = "${local.userprefix}82", group_display_name = local.training_group_name }
    # "${local.userprefix}83" = { name = "${local.userprefix}83", group_display_name = local.training_group_name }
    # "${local.userprefix}84" = { name = "${local.userprefix}84", group_display_name = local.training_group_name }
    # "${local.userprefix}85" = { name = "${local.userprefix}85", group_display_name = local.training_group_name }
    # "${local.userprefix}86" = { name = "${local.userprefix}86", group_display_name = local.training_group_name }
    # "${local.userprefix}87" = { name = "${local.userprefix}87", group_display_name = local.training_group_name }
    # "${local.userprefix}88" = { name = "${local.userprefix}88", group_display_name = local.training_group_name }
    # "${local.userprefix}89" = { name = "${local.userprefix}89", group_display_name = local.training_group_name }
    # "${local.userprefix}90" = { name = "${local.userprefix}90", group_display_name = local.training_group_name }
    # "${local.userprefix}90" = { name = "${local.userprefix}90", group_display_name = local.training_group_name }
    # "${local.userprefix}91" = { name = "${local.userprefix}91", group_display_name = local.training_group_name }
    # "${local.userprefix}92" = { name = "${local.userprefix}92", group_display_name = local.training_group_name }
    # "${local.userprefix}93" = { name = "${local.userprefix}93", group_display_name = local.training_group_name }
    # "${local.userprefix}94" = { name = "${local.userprefix}94", group_display_name = local.training_group_name }
    # "${local.userprefix}95" = { name = "${local.userprefix}95", group_display_name = local.training_group_name }
    # "${local.userprefix}96" = { name = "${local.userprefix}96", group_display_name = local.training_group_name }
    # "${local.userprefix}97" = { name = "${local.userprefix}97", group_display_name = local.training_group_name }
    # "${local.userprefix}98" = { name = "${local.userprefix}98", group_display_name = local.training_group_name }
    # "${local.userprefix}99" = { name = "${local.userprefix}99", group_display_name = local.training_group_name }
  }
}