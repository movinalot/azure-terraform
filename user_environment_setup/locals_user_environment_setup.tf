locals {
  directory_roles = {
    "Application Administrator" = {
      display_name = "Application Administrator"
    }
    "Global Reader" = {
      display_name = "Global Reader"
    }
  }

  directory_role_members = {
    "Application Administrator" = {
      role_object_id   = module.module_azuread_directory_role["Application Administrator"].directory_role.object_id
      member_object_id = module.module_azuread_group["FTNT_External_Training"].group.object_id
    }
    "Global Reader" = {
      role_object_id   = module.module_azuread_directory_role["Global Reader"].directory_role.object_id
      member_object_id = module.module_azuread_group["FTNT_External_Training"].group.object_id
    }
  }

  role_assignments = {
    "Contributor" = {
      scope                = data.azurerm_subscription.subscription.id
      role_definition_name = "Contributor"
      principal_id         = module.module_azuread_group["FTNT_External_Training"].group.id
    }
    "User Access Administrator" = {
      scope                = data.azurerm_subscription.subscription.id
      role_definition_name = "User Access Administrator"
      principal_id         = module.module_azuread_group["FTNT_External_Training"].group.id
    }
  }

  groups = {
    "FTNT_External_Training" = {
      display_name       = "FTNT_External_Training"
      owners             = data.azuread_users.users["FTNT_External_Training"].object_ids
      security_enabled   = true
      assignable_to_role = true
    }
  }

  user_common = {
    user_principal_name_ext          = var.user_principal_name_ext
    display_name_ext                 = ""
    password                         = var.user_password
    account_enabled                  = true
    storage_share_name               = "cloudshell"
    storage_share_quota              = 50
    storage_prefix                   = "setrain"
    storage_account_tier             = "Standard"
    storage_account_replication_type = "LRS"
  }

  users = {
    "student01" = { name = "student01", location = "eastus", group_display_name = "FTNT_External_Training" }
    "student02" = { name = "student02", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student03" = { name = "student03", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student04" = { name = "student04", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student05" = { name = "student05", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student06" = { name = "student06", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student07" = { name = "student07", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student08" = { name = "student08", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student09" = { name = "student09", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student10" = { name = "student10", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student11" = { name = "student11", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student12" = { name = "student12", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student13" = { name = "student13", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student14" = { name = "student14", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student15" = { name = "student15", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student16" = { name = "student16", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student17" = { name = "student17", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student18" = { name = "student18", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student19" = { name = "student19", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student20" = { name = "student20", location = "eastus", group_display_name = "FTNT_External_Training" }
    # "student21" = { name = "student21", location = "eastus" }
    # "student22" = { name = "student22", location = "eastus" }
    # "student23" = { name = "student23", location = "eastus" }
    # "student24" = { name = "student24", location = "eastus" }
    # "student25" = { name = "student25", location = "eastus" }
    # "student26" = { name = "student26", location = "eastus" }
    # "student27" = { name = "student27", location = "eastus" }
    # "student28" = { name = "student28", location = "eastus" }
    # "student29" = { name = "student29", location = "eastus" }
    # "student30" = { name = "student30", location = "eastus" }
    # "student31" = { name = "student31", location = "eastus" }
    # "student32" = { name = "student32", location = "eastus" }
    # "student33" = { name = "student33", location = "eastus" }
    # "student34" = { name = "student34", location = "eastus" }
    # "student35" = { name = "student35", location = "eastus" }
    # "student36" = { name = "student36", location = "eastus" }
    # "student37" = { name = "student37", location = "eastus" }
    # "student38" = { name = "student38", location = "eastus" }
    # "student39" = { name = "student39", location = "eastus" }
    # "student40" = { name = "student40", location = "eastus" }
    # "student41" = { name = "student41", location = "eastus" }
    # "student42" = { name = "student42", location = "eastus" }
    # "student43" = { name = "student43", location = "eastus" }
    # "student44" = { name = "student44", location = "eastus" }
    # "student45" = { name = "student45", location = "eastus" }
    # "student46" = { name = "student46", location = "eastus" }
    # "student47" = { name = "student47", location = "eastus" }
    # "student48" = { name = "student48", location = "eastus" }
    # "student49" = { name = "student49", location = "eastus" }
    # "student50" = { name = "student50", location = "eastus" }
    # "student51" = { name = "student51", location = "eastus" }
    # "student52" = { name = "student52", location = "eastus" }
    # "student53" = { name = "student53", location = "eastus" }
    # "student54" = { name = "student54", location = "eastus" }
    # "student55" = { name = "student55", location = "eastus" }
    # "student56" = { name = "student56", location = "eastus" }
    # "student57" = { name = "student57", location = "eastus" }
    # "student58" = { name = "student58", location = "eastus" }
    # "student59" = { name = "student59", location = "eastus" }
    # "student60" = { name = "student60", location = "eastus" }
    # "student61" = { name = "student61", location = "eastus" }
    # "student62" = { name = "student62", location = "eastus" }
    # "student63" = { name = "student63", location = "eastus" }
    # "student64" = { name = "student64", location = "eastus" }
    # "student65" = { name = "student65", location = "eastus" }
    # "student66" = { name = "student66", location = "eastus" }
    # "student67" = { name = "student67", location = "eastus" }
    # "student68" = { name = "student68", location = "eastus" }
    # "student69" = { name = "student69", location = "eastus" }
    # "student70" = { name = "student70", location = "eastus" }
    # "student71" = { name = "student71", location = "eastus" }
    # "student72" = { name = "student72", location = "eastus" }
    # "student73" = { name = "student73", location = "eastus" }
    # "student74" = { name = "student74", location = "eastus" }
    # "student75" = { name = "student75", location = "eastus" }
    # "student76" = { name = "student76", location = "eastus" }
    # "student77" = { name = "student77", location = "eastus" }
    # "student78" = { name = "student78", location = "eastus" }
    # "student79" = { name = "student79", location = "eastus" }
    # "student80" = { name = "student80", location = "westus" }
    # "student81" = { name = "student81", location = "westus" }
    # "student82" = { name = "student82", location = "westus" }
    # "student83" = { name = "student83", location = "westus" }
    # "student84" = { name = "student84", location = "westus" }
    # "student85" = { name = "student85", location = "westus" }
    # "student86" = { name = "student86", location = "westus" }
    # "student87" = { name = "student87", location = "westus" }
    # "student88" = { name = "student88", location = "westus" }
    # "student89" = { name = "student89", location = "westus" }
    # "student90" = { name = "student90", location = "westus" }
    # "student90" = { name = "student90", location = "eastus" }
    # "student91" = { name = "student91", location = "eastus" }
    # "student92" = { name = "student92", location = "eastus" }
    # "student93" = { name = "student93", location = "eastus" }
    # "student94" = { name = "student94", location = "eastus" }
    # "student95" = { name = "student95", location = "eastus" }
    # "student96" = { name = "student96", location = "eastus" }
    # "student97" = { name = "student97", location = "eastus" }
    # "student98" = { name = "student98", location = "eastus" }
    # "student99" = { name = "student99", location = "eastus" }
  }
}