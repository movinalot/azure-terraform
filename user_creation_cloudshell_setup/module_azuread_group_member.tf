module "module_azuread_group_member" {
  for_each = var.users

  source = "../azure/ad/azuread_group_member"

  group_object_id  = module.module_azuread_group[var.user_common["group_display_name"]].group.id
  member_object_id = module.module_azuread_user[each.value.name].user.id

  depends_on = [
    module.module_azuread_group
  ]
}

output "group_members" {
  value = module.module_azuread_group_member[*]
}
