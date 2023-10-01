module "module_azuread_group_member" {
  for_each = local.users

  source = "git::https://github.com/movinalot/azure.git//ad/azuread_group_member"

  #source = "../azure/ad/azuread_group_member"

  group_object_id  = module.module_azuread_group[each.value.group_display_name].group.id
  member_object_id = module.module_azuread_user[each.value.name].user.id
}

output "group_members" {
  value = var.enable_module_output ? module.module_azuread_group_member[*] : null
}
