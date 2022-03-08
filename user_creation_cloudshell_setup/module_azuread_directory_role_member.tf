module "module_azuread_directory_role_member" {
  for_each = var.directory_role_assignments

  source = "../azure/ad/azuread_directory_role_member"

  role_object_id   = module.module_azuread_directory_role[each.value.display_name].directory_role.object_id
  member_object_id = module.module_azuread_group[each.value.group_display_name].group.object_id
}

output "directory_role_members" {
  value = module.module_azuread_directory_role_member[*]
}
