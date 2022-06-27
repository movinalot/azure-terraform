locals {
  directory_roles = {
    "Application Administrator" = {
      display_name = "Application Administrator"
    }
    "Global Reader" = {
      display_name = "Global Reader"
    }
  }

  user_role_definition_names = ["Contributor", "User Access Administrator"]

  directory_role_assignments = {

  }

  directory_role_members = {
    "Application Administrator" = {
      role_object_id   = module.module_azuread_directory_role["Application Administrator"].directory_role.object_id
      member_object_id = module.module_azuread_group[var.training_group].group.object_id
    }
    "Global Reader" = {
      role_object_id   = module.module_azuread_directory_role["Global Reader"].directory_role.object_id
      member_object_id = module.module_azuread_group[var.training_group].group.object_id
    }
  }

  groups = {
    (var.training_group) = {
      display_name       = var.training_group
      owners             = data.azuread_users.users[var.training_group].object_ids
      security_enabled   = true
      assignable_to_role = true
    }
  }

  resource_group_suffix = "_fortisoar_fortianalyzer_fortigate"

  user_common = {
    user_principal_name_ext          = var.user_principal_name_ext
    display_name_ext                 = ""
    password                         = var.user_password
    account_enabled                  = true
    storage_share_name               = "cloudshell"
    storage_share_quota              = 50
    storage_prefix                   = "csetrn"
    storage_account_tier             = "Standard"
    storage_account_replication_type = "LRS"
  }

  users = {
    "cse01" = { name = "cse01", location = "eastus", group_display_name = var.training_group }
    "cse02" = { name = "cse02", location = "eastus", group_display_name = var.training_group }
    # "cse03" = { name = "cse03", location = "eastus", group_display_name = var.training_group }
    # "cse04" = { name = "cse04", location = "eastus", group_display_name = var.training_group }
    # "cse05" = { name = "cse05", location = "eastus", group_display_name = var.training_group }
    # "cse06" = { name = "cse06", location = "eastus", group_display_name = var.training_group }
    # "cse07" = { name = "cse07", location = "eastus", group_display_name = var.training_group }
    # "cse08" = { name = "cse08", location = "eastus", group_display_name = var.training_group }
    # "cse09" = { name = "cse09", location = "eastus", group_display_name = var.training_group }
    # "cse10" = { name = "cse10", location = "eastus", group_display_name = var.training_group }
    # "cse11" = { name = "cse11", location = "eastus", group_display_name = var.training_group }
    # "cse12" = { name = "cse12", location = "eastus", group_display_name = var.training_group }
    # "cse13" = { name = "cse13", location = "eastus", group_display_name = var.training_group }
    # "cse14" = { name = "cse14", location = "eastus", group_display_name = var.training_group }
    # "cse15" = { name = "cse15", location = "eastus", group_display_name = var.training_group }
    # "cse16" = { name = "cse16", location = "eastus", group_display_name = var.training_group }
    # "cse17" = { name = "cse17", location = "eastus", group_display_name = var.training_group }
    # "cse18" = { name = "cse18", location = "eastus", group_display_name = var.training_group }
    # "cse19" = { name = "cse19", location = "eastus", group_display_name = var.training_group }
    # "cse20" = { name = "cse20", location = "eastus", group_display_name = var.training_group }
    # "cse21" = { name = "cse21", location = "eastus", group_display_name = var.training_group }
    # "cse22" = { name = "cse22", location = "eastus", group_display_name = var.training_group }
    # "cse23" = { name = "cse23", location = "eastus", group_display_name = var.training_group }
    # "cse24" = { name = "cse24", location = "eastus", group_display_name = var.training_group }
    # "cse25" = { name = "cse25", location = "eastus", group_display_name = var.training_group }
    # "cse26" = { name = "cse26", location = "eastus", group_display_name = var.training_group }
    # "cse27" = { name = "cse27", location = "eastus", group_display_name = var.training_group }
    # "cse28" = { name = "cse28", location = "eastus", group_display_name = var.training_group }
    # "cse29" = { name = "cse29", location = "eastus", group_display_name = var.training_group }
    # "cse30" = { name = "cse30", location = "eastus", group_display_name = var.training_group }
    # "cse31" = { name = "cse31", location = "eastus", group_display_name = var.training_group }
    # "cse32" = { name = "cse32", location = "eastus", group_display_name = var.training_group }
    # "cse33" = { name = "cse33", location = "eastus", group_display_name = var.training_group }
    # "cse34" = { name = "cse34", location = "eastus", group_display_name = var.training_group }
    # "cse35" = { name = "cse35", location = "eastus", group_display_name = var.training_group }
    # "cse36" = { name = "cse36", location = "eastus", group_display_name = var.training_group }
    # "cse37" = { name = "cse37", location = "eastus", group_display_name = var.training_group }
    # "cse38" = { name = "cse38", location = "eastus", group_display_name = var.training_group }
    # "cse39" = { name = "cse39", location = "eastus", group_display_name = var.training_group }
    # "cse40" = { name = "cse40", location = "eastus", group_display_name = var.training_group }
    # "student41" = { name = "student41", location = "eastus", group_display_name = var.training_group }
    # "student42" = { name = "student42", location = "eastus", group_display_name = var.training_group }
    # "student43" = { name = "student43", location = "eastus", group_display_name = var.training_group }
    # "student44" = { name = "student44", location = "eastus", group_display_name = var.training_group }
    # "student45" = { name = "student45", location = "eastus", group_display_name = var.training_group }
    # "student46" = { name = "student46", location = "eastus", group_display_name = var.training_group }
    # "student47" = { name = "student47", location = "eastus", group_display_name = var.training_group }
    # "student48" = { name = "student48", location = "eastus", group_display_name = var.training_group }
    # "student49" = { name = "student49", location = "eastus", group_display_name = var.training_group }
    # "student50" = { name = "student50", location = "eastus", group_display_name = var.training_group }
    # "student51" = { name = "student51", location = "eastus", group_display_name = var.training_group }
    # "student52" = { name = "student52", location = "eastus", group_display_name = var.training_group }
    # "student53" = { name = "student53", location = "eastus", group_display_name = var.training_group }
    # "student54" = { name = "student54", location = "eastus", group_display_name = var.training_group }
    # "student55" = { name = "student55", location = "eastus", group_display_name = var.training_group }
    # "student56" = { name = "student56", location = "eastus", group_display_name = var.training_group }
    # "student57" = { name = "student57", location = "eastus", group_display_name = var.training_group }
    # "student58" = { name = "student58", location = "eastus", group_display_name = var.training_group }
    # "student59" = { name = "student59", location = "eastus", group_display_name = var.training_group }
    # "student60" = { name = "student60", location = "eastus", group_display_name = var.training_group }
    # "student61" = { name = "student61", location = "eastus", group_display_name = var.training_group }
    # "student62" = { name = "student62", location = "eastus", group_display_name = var.training_group }
    # "student63" = { name = "student63", location = "eastus", group_display_name = var.training_group }
    # "student64" = { name = "student64", location = "eastus", group_display_name = var.training_group }
    # "student65" = { name = "student65", location = "eastus", group_display_name = var.training_group }
    # "student66" = { name = "student66", location = "eastus", group_display_name = var.training_group }
    # "student67" = { name = "student67", location = "eastus", group_display_name = var.training_group }
    # "student68" = { name = "student68", location = "eastus", group_display_name = var.training_group }
    # "student69" = { name = "student69", location = "eastus", group_display_name = var.training_group }
    # "student70" = { name = "student70", location = "eastus", group_display_name = var.training_group }
    # "student71" = { name = "student71", location = "eastus", group_display_name = var.training_group }
    # "student72" = { name = "student72", location = "eastus", group_display_name = var.training_group }
    # "student73" = { name = "student73", location = "eastus", group_display_name = var.training_group }
    # "student74" = { name = "student74", location = "eastus", group_display_name = var.training_group }
    # "student75" = { name = "student75", location = "eastus", group_display_name = var.training_group }
    # "student76" = { name = "student76", location = "eastus", group_display_name = var.training_group }
    # "student77" = { name = "student77", location = "eastus", group_display_name = var.training_group }
    # "student78" = { name = "student78", location = "eastus", group_display_name = var.training_group }
    # "student79" = { name = "student79", location = "eastus", group_display_name = var.training_group }
    # "student80" = { name = "student80", location = "westus", group_display_name = var.training_group }
    # "student81" = { name = "student81", location = "westus", group_display_name = var.training_group }
    # "student82" = { name = "student82", location = "westus", group_display_name = var.training_group }
    # "student83" = { name = "student83", location = "westus", group_display_name = var.training_group }
    # "student84" = { name = "student84", location = "westus", group_display_name = var.training_group }
    # "student85" = { name = "student85", location = "westus", group_display_name = var.training_group }
    # "student86" = { name = "student86", location = "westus", group_display_name = var.training_group }
    # "student87" = { name = "student87", location = "westus", group_display_name = var.training_group }
    # "student88" = { name = "student88", location = "westus", group_display_name = var.training_group }
    # "student89" = { name = "student89", location = "westus", group_display_name = var.training_group }
    # "student90" = { name = "student90", location = "westus", group_display_name = var.training_group }
    # "student90" = { name = "student90", location = "eastus", group_display_name = var.training_group }
    # "student91" = { name = "student91", location = "eastus", group_display_name = var.training_group }
    # "student92" = { name = "student92", location = "eastus", group_display_name = var.training_group }
    # "student93" = { name = "student93", location = "eastus", group_display_name = var.training_group }
    # "student94" = { name = "student94", location = "eastus", group_display_name = var.training_group }
    # "student95" = { name = "student95", location = "eastus", group_display_name = var.training_group }
    # "student96" = { name = "student96", location = "eastus", group_display_name = var.training_group }
    # "student97" = { name = "student97", location = "eastus", group_display_name = var.training_group }
    # "student98" = { name = "student98", location = "eastus", group_display_name = var.training_group }
    # "student99" = { name = "student99", location = "eastus", group_display_name = var.training_group }
  }
}