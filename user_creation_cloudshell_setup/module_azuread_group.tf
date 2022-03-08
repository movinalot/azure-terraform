data "azuread_users" "users" {
  for_each = var.groups

  user_principal_names = var.groups[each.value.display_name].owners
}

module "module_azuread_group" {
  for_each = var.groups

  source = "../azure/ad/azuread_group"

  display_name       = each.value.display_name
  owners             = data.azuread_users.users[each.value.display_name].object_ids
  security_enabled   = true
  assignable_to_role = true
}

output "groups" {
  value = module.module_azuread_group[*]
}
