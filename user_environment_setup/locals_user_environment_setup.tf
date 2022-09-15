locals {

  bastion_host_support       = false
  per_user_service_principle = false
  per_user_service_principle_role = "Owner"

  # Training Group name
  training_group_name = "TRAINING_GROUP_CHANGE_ME"

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
      suffix   = "training"
      location = "eastus"
      storage  = true
      bastion  = true
    },
    {
      suffix   = "fgtaa"
      location = "eastus"
      storage  = false
      bastion  = false
    },
    {
      suffix   = "fgtap"
      location = "eastus"
      storage  = false
      bastion  = false
    },
    {
      suffix   = "fwb"
      location = "eastus"
      storage  = false
      bastion  = false
    }
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
      role_definition_name = item[1], username = item[0]["username"]
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

    utility_vnet_name          = "vnet_utility"
    utility_vnet_address_space = ["192.168.100.0/24"]

    linux_vm_size = "Standard_D2_v3"
  }

  users = {
    # "cse01" = { name = "cse01", group_display_name = local.training_group_name }
    # "cse02" = { name = "cse02", group_display_name = local.training_group_name }
    # "cse03" = { name = "cse03", group_display_name = local.training_group_name }
    # "cse04" = { name = "cse04", group_display_name = local.training_group_name }
    # "cse05" = { name = "cse05", group_display_name = local.training_group_name }
    # "cse06" = { name = "cse06", group_display_name = local.training_group_name }
    # "cse07" = { name = "cse07", group_display_name = local.training_group_name }
    # "cse08" = { name = "cse08", group_display_name = local.training_group_name }
    # "cse09" = { name = "cse09", group_display_name = local.training_group_name }
    # "cse10" = { name = "cse10", group_display_name = local.training_group_name }
    # "cse11" = { name = "cse11", group_display_name = local.training_group_name }
    # "cse12" = { name = "cse12", group_display_name = local.training_group_name }
    # "cse13" = { name = "cse13", group_display_name = local.training_group_name }
    # "cse14" = { name = "cse14", group_display_name = local.training_group_name }
    # "cse15" = { name = "cse15", group_display_name = local.training_group_name }
    # "cse16" = { name = "cse16", group_display_name = local.training_group_name }
    # "cse17" = { name = "cse17", group_display_name = local.training_group_name }
    # "cse18" = { name = "cse18", group_display_name = local.training_group_name }
    # "cse19" = { name = "cse19", group_display_name = local.training_group_name }
    # "cse20" = { name = "cse20", group_display_name = local.training_group_name }
    # "cse21" = { name = "cse21", group_display_name = local.training_group_name }
    # "cse22" = { name = "cse22", group_display_name = local.training_group_name }
    # "cse23" = { name = "cse23", group_display_name = local.training_group_name }
    # "cse24" = { name = "cse24", group_display_name = local.training_group_name }
    # "cse25" = { name = "cse25", group_display_name = local.training_group_name }
    # "cse26" = { name = "cse26", group_display_name = local.training_group_name }
    # "cse27" = { name = "cse27", group_display_name = local.training_group_name }
    # "cse28" = { name = "cse28", group_display_name = local.training_group_name }
    # "cse29" = { name = "cse29", group_display_name = local.training_group_name }
    # "cse30" = { name = "cse30", group_display_name = local.training_group_name }
    # "cse31" = { name = "cse31", group_display_name = local.training_group_name }
    # "cse32" = { name = "cse32", group_display_name = local.training_group_name }
    # "cse33" = { name = "cse33", group_display_name = local.training_group_name }
    # "cse34" = { name = "cse34", group_display_name = local.training_group_name }
    # "cse35" = { name = "cse35", group_display_name = local.training_group_name }
    # "cse36" = { name = "cse36", group_display_name = local.training_group_name }
    # "cse37" = { name = "cse37", group_display_name = local.training_group_name }
    # "cse38" = { name = "cse38", group_display_name = local.training_group_name }
    # "cse39" = { name = "cse39", group_display_name = local.training_group_name }
    # "cse40" = { name = "cse40", group_display_name = local.training_group_name }
    # "cse41" = { name = "cse41", group_display_name = local.training_group_name }
    # "cse42" = { name = "cse42", group_display_name = local.training_group_name }
    # "cse43" = { name = "cse43", group_display_name = local.training_group_name }
    # "cse44" = { name = "cse44", group_display_name = local.training_group_name }
    # "cse45" = { name = "cse45", group_display_name = local.training_group_name }
    # "cse46" = { name = "cse46", group_display_name = local.training_group_name }
    # "cse47" = { name = "cse47", group_display_name = local.training_group_name }
    # "cse48" = { name = "cse48", group_display_name = local.training_group_name }
    # "cse49" = { name = "cse49", group_display_name = local.training_group_name }
    # "cse50" = { name = "cse50", group_display_name = local.training_group_name }
    # "cse51" = { name = "cse51", group_display_name = local.training_group_name }
    # "cse52" = { name = "cse52", group_display_name = local.training_group_name }
    # "cse53" = { name = "cse53", group_display_name = local.training_group_name }
    # "cse54" = { name = "cse54", group_display_name = local.training_group_name }
    # "cse55" = { name = "cse55", group_display_name = local.training_group_name }
    # "cse56" = { name = "cse56", group_display_name = local.training_group_name }
    # "cse57" = { name = "cse57", group_display_name = local.training_group_name }
    # "cse58" = { name = "cse58", group_display_name = local.training_group_name }
    # "cse59" = { name = "cse59", group_display_name = local.training_group_name }
    # "cse60" = { name = "cse60", group_display_name = local.training_group_name }
    # "cse61" = { name = "cse61", group_display_name = local.training_group_name }
    # "cse62" = { name = "cse62", group_display_name = local.training_group_name }
    # "cse63" = { name = "cse63", group_display_name = local.training_group_name }
    # "cse64" = { name = "cse64", group_display_name = local.training_group_name }
    # "cse65" = { name = "cse65", group_display_name = local.training_group_name }
    # "cse66" = { name = "cse66", group_display_name = local.training_group_name }
    # "cse67" = { name = "cse67", group_display_name = local.training_group_name }
    # "cse68" = { name = "cse68", group_display_name = local.training_group_name }
    # "cse69" = { name = "cse69", group_display_name = local.training_group_name }
    # "cse70" = { name = "cse70", group_display_name = local.training_group_name }
    # "cse71" = { name = "cse71", group_display_name = local.training_group_name }
    # "cse72" = { name = "cse72", group_display_name = local.training_group_name }
    # "cse73" = { name = "cse73", group_display_name = local.training_group_name }
    # "cse74" = { name = "cse74", group_display_name = local.training_group_name }
    # "cse75" = { name = "cse75", group_display_name = local.training_group_name }
    # "cse76" = { name = "cse76", group_display_name = local.training_group_name }
    # "cse77" = { name = "cse77", group_display_name = local.training_group_name }
    # "cse78" = { name = "cse78", group_display_name = local.training_group_name }
    # "cse79" = { name = "cse79", group_display_name = local.training_group_name }
    # "cse80" = { name = "cse80", group_display_name = local.training_group_name }
    # "cse81" = { name = "cse81", group_display_name = local.training_group_name }
    # "cse82" = { name = "cse82", group_display_name = local.training_group_name }
    # "cse83" = { name = "cse83", group_display_name = local.training_group_name }
    # "cse84" = { name = "cse84", group_display_name = local.training_group_name }
    # "cse85" = { name = "cse85", group_display_name = local.training_group_name }
    # "cse86" = { name = "cse86", group_display_name = local.training_group_name }
    # "cse87" = { name = "cse87", group_display_name = local.training_group_name }
    # "cse88" = { name = "cse88", group_display_name = local.training_group_name }
    # "cse89" = { name = "cse89", group_display_name = local.training_group_name }
    # "cse90" = { name = "cse90", group_display_name = local.training_group_name }
    # "cse90" = { name = "cse90", group_display_name = local.training_group_name }
    # "cse91" = { name = "cse91", group_display_name = local.training_group_name }
    # "cse92" = { name = "cse92", group_display_name = local.training_group_name }
    # "cse93" = { name = "cse93", group_display_name = local.training_group_name }
    # "cse94" = { name = "cse94", group_display_name = local.training_group_name }
    # "cse95" = { name = "cse95", group_display_name = local.training_group_name }
    # "cse96" = { name = "cse96", group_display_name = local.training_group_name }
    # "cse97" = { name = "cse97", group_display_name = local.training_group_name }
    # "cse98" = { name = "cse98", group_display_name = local.training_group_name }
    # "cse99" = { name = "cse99", group_display_name = local.training_group_name }
  }
}