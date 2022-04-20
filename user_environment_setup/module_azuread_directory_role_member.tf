module "module_azuread_directory_role_member" {
  for_each = local.directory_role_members

  source = "../azure/ad/azuread_directory_role_member"

  role_object_id   = each.value.role_object_id
  member_object_id = each.value.member_object_id
}

output "directory_role_members" {
  value = var.enable_module_output ? module.module_azuread_directory_role_member[*] : null
}
