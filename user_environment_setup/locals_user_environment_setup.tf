locals {

  # Training Group name
  training_group = "CSE_Training"

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
      role_id             = module.module_azuread_directory_role["Application Administrator"].directory_role.object_id
      principal_object_id = module.module_azuread_group[local.training_group].group.object_id
    }
    "Global Reader" = {
      role_id             = module.module_azuread_directory_role["Global Reader"].directory_role.object_id
      principal_object_id = module.module_azuread_group[local.training_group].group.object_id
    }
  }

  groups = {
    (local.training_group) = {
      display_name       = local.training_group
      owners             = data.azuread_users.users[local.training_group].object_ids
      security_enabled   = true
      assignable_to_role = true
    }
  }

  group_owners = {
    (local.training_group) = {
      owners = var.training_group_owners
    }
  }

  # User roles that will be assigned to the user's Resource Group
  user_role_definition_names = setproduct(values(local.users), ["Contributor", "User Access Administrator"])

  # Resource Group name will be "username-resource_group_suffix"
  resource_group_suffix = "workshop-sdwan"

  # Common User attributes
  user_common = {
    user_principal_name_ext          = var.user_principal_name_ext
    display_name_ext                 = ""
    password                         = var.user_password
    account_enabled                  = true
    storage_share_name               = "cloudshell"
    storage_share_quota              = 50
    storage_prefix                   = "train"
    storage_account_tier             = "Standard"
    storage_account_replication_type = "LRS"
  }

  users = {
    "cse01" = { name = "cse01", location = "eastus", group_display_name = local.training_group }
    "cse02" = { name = "cse02", location = "eastus", group_display_name = local.training_group }
    "cse03" = { name = "cse03", location = "eastus", group_display_name = local.training_group }
    "cse04" = { name = "cse04", location = "eastus", group_display_name = local.training_group }
    "cse05" = { name = "cse05", location = "eastus", group_display_name = local.training_group }
    #"cse06" = { name = "cse06", location = "eastus", group_display_name = local.training_group }
    # "cse07" = { name = "cse07", location = "eastus", group_display_name = local.training_group }
    # "cse08" = { name = "cse08", location = "eastus", group_display_name = local.training_group }
    # "cse09" = { name = "cse09", location = "eastus", group_display_name = local.training_group }
    # "cse10" = { name = "cse10", location = "eastus", group_display_name = local.training_group }
    # "cse11" = { name = "cse11", location = "eastus", group_display_name = local.training_group }
    # "cse12" = { name = "cse12", location = "eastus", group_display_name = local.training_group }
    # "cse13" = { name = "cse13", location = "eastus", group_display_name = local.training_group }
    # "cse14" = { name = "cse14", location = "eastus", group_display_name = local.training_group }
    # "cse15" = { name = "cse15", location = "eastus", group_display_name = local.training_group }
    # "cse16" = { name = "cse16", location = "eastus", group_display_name = local.training_group }
    # "cse17" = { name = "cse17", location = "eastus", group_display_name = local.training_group }
    # "cse18" = { name = "cse18", location = "eastus", group_display_name = local.training_group }
    # "cse19" = { name = "cse19", location = "eastus", group_display_name = local.training_group }
    # "cse20" = { name = "cse20", location = "eastus", group_display_name = local.training_group }
    # "cse21" = { name = "cse21", location = "eastus", group_display_name = local.training_group }
    # "cse22" = { name = "cse22", location = "eastus", group_display_name = local.training_group }
    # "cse23" = { name = "cse23", location = "eastus", group_display_name = local.training_group }
    # "cse24" = { name = "cse24", location = "eastus", group_display_name = local.training_group }
    # "cse25" = { name = "cse25", location = "eastus", group_display_name = local.training_group }
    # "cse26" = { name = "cse26", location = "eastus", group_display_name = local.training_group }
    # "cse27" = { name = "cse27", location = "eastus", group_display_name = local.training_group }
    # "cse28" = { name = "cse28", location = "eastus", group_display_name = local.training_group }
    # "cse29" = { name = "cse29", location = "eastus", group_display_name = local.training_group }
    # "cse30" = { name = "cse30", location = "eastus", group_display_name = local.training_group }
    # "cse31" = { name = "cse31", location = "eastus", group_display_name = local.training_group }
    # "cse32" = { name = "cse32", location = "eastus", group_display_name = local.training_group }
    # "cse33" = { name = "cse33", location = "eastus", group_display_name = local.training_group }
    # "cse34" = { name = "cse34", location = "eastus", group_display_name = local.training_group }
    # "cse35" = { name = "cse35", location = "eastus", group_display_name = local.training_group }
    # "cse36" = { name = "cse36", location = "eastus", group_display_name = local.training_group }
    # "cse37" = { name = "cse37", location = "eastus", group_display_name = local.training_group }
    # "cse38" = { name = "cse38", location = "eastus", group_display_name = local.training_group }
    # "cse39" = { name = "cse39", location = "eastus", group_display_name = local.training_group }
    # "cse40" = { name = "cse40", location = "eastus", group_display_name = local.training_group }
    # "cse41" = { name = "cse41", location = "eastus", group_display_name = local.training_group }
    # "cse42" = { name = "cse42", location = "eastus", group_display_name = local.training_group }
    # "cse43" = { name = "cse43", location = "eastus", group_display_name = local.training_group }
    # "cse44" = { name = "cse44", location = "eastus", group_display_name = local.training_group }
    # "cse45" = { name = "cse45", location = "eastus", group_display_name = local.training_group }
    # "cse46" = { name = "cse46", location = "eastus", group_display_name = local.training_group }
    # "cse47" = { name = "cse47", location = "eastus", group_display_name = local.training_group }
    # "cse48" = { name = "cse48", location = "eastus", group_display_name = local.training_group }
    # "cse49" = { name = "cse49", location = "eastus", group_display_name = local.training_group }
    # "cse50" = { name = "cse50", location = "eastus", group_display_name = local.training_group }
    # "cse51" = { name = "cse51", location = "eastus", group_display_name = local.training_group }
    # "cse52" = { name = "cse52", location = "eastus", group_display_name = local.training_group }
    # "cse53" = { name = "cse53", location = "eastus", group_display_name = local.training_group }
    # "cse54" = { name = "cse54", location = "eastus", group_display_name = local.training_group }
    # "cse55" = { name = "cse55", location = "eastus", group_display_name = local.training_group }
    # "cse56" = { name = "cse56", location = "eastus", group_display_name = local.training_group }
    # "cse57" = { name = "cse57", location = "eastus", group_display_name = local.training_group }
    # "cse58" = { name = "cse58", location = "eastus", group_display_name = local.training_group }
    # "cse59" = { name = "cse59", location = "eastus", group_display_name = local.training_group }
    # "cse60" = { name = "cse60", location = "eastus", group_display_name = local.training_group }
    # "cse61" = { name = "cse61", location = "eastus", group_display_name = local.training_group }
    # "cse62" = { name = "cse62", location = "eastus", group_display_name = local.training_group }
    # "cse63" = { name = "cse63", location = "eastus", group_display_name = local.training_group }
    # "cse64" = { name = "cse64", location = "eastus", group_display_name = local.training_group }
    # "cse65" = { name = "cse65", location = "eastus", group_display_name = local.training_group }
    # "cse66" = { name = "cse66", location = "eastus", group_display_name = local.training_group }
    # "cse67" = { name = "cse67", location = "eastus", group_display_name = local.training_group }
    # "cse68" = { name = "cse68", location = "eastus", group_display_name = local.training_group }
    # "cse69" = { name = "cse69", location = "eastus", group_display_name = local.training_group }
    # "cse70" = { name = "cse70", location = "eastus", group_display_name = local.training_group }
    # "cse71" = { name = "cse71", location = "eastus", group_display_name = local.training_group }
    # "cse72" = { name = "cse72", location = "eastus", group_display_name = local.training_group }
    # "cse73" = { name = "cse73", location = "eastus", group_display_name = local.training_group }
    # "cse74" = { name = "cse74", location = "eastus", group_display_name = local.training_group }
    # "cse75" = { name = "cse75", location = "eastus", group_display_name = local.training_group }
    # "cse76" = { name = "cse76", location = "eastus", group_display_name = local.training_group }
    # "cse77" = { name = "cse77", location = "eastus", group_display_name = local.training_group }
    # "cse78" = { name = "cse78", location = "eastus", group_display_name = local.training_group }
    # "cse79" = { name = "cse79", location = "eastus", group_display_name = local.training_group }
    # "cse80" = { name = "cse80", location = "westus", group_display_name = local.training_group }
    # "cse81" = { name = "cse81", location = "westus", group_display_name = local.training_group }
    # "cse82" = { name = "cse82", location = "westus", group_display_name = local.training_group }
    # "cse83" = { name = "cse83", location = "westus", group_display_name = local.training_group }
    # "cse84" = { name = "cse84", location = "westus", group_display_name = local.training_group }
    # "cse85" = { name = "cse85", location = "westus", group_display_name = local.training_group }
    # "cse86" = { name = "cse86", location = "westus", group_display_name = local.training_group }
    # "cse87" = { name = "cse87", location = "westus", group_display_name = local.training_group }
    # "cse88" = { name = "cse88", location = "westus", group_display_name = local.training_group }
    # "cse89" = { name = "cse89", location = "westus", group_display_name = local.training_group }
    # "cse90" = { name = "cse90", location = "westus", group_display_name = local.training_group }
    # "cse90" = { name = "cse90", location = "eastus", group_display_name = local.training_group }
    # "cse91" = { name = "cse91", location = "eastus", group_display_name = local.training_group }
    # "cse92" = { name = "cse92", location = "eastus", group_display_name = local.training_group }
    # "cse93" = { name = "cse93", location = "eastus", group_display_name = local.training_group }
    # "cse94" = { name = "cse94", location = "eastus", group_display_name = local.training_group }
    # "cse95" = { name = "cse95", location = "eastus", group_display_name = local.training_group }
    # "cse96" = { name = "cse96", location = "eastus", group_display_name = local.training_group }
    # "cse97" = { name = "cse97", location = "eastus", group_display_name = local.training_group }
    # "cse98" = { name = "cse98", location = "eastus", group_display_name = local.training_group }
    # "cse99" = { name = "cse99", location = "eastus", group_display_name = local.training_group }
  }
}