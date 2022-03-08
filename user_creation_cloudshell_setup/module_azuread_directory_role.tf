module "module_azuread_directory_role" {
  for_each = var.directory_role_assignments

  source = "../azure/ad/azuread_directory_role"

  display_name = each.value.display_name
}

output "directory_roles" {
  value = module.module_azuread_directory_role[*]
}
