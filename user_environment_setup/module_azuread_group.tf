module "module_azuread_group" {
  for_each = local.groups

  source = "git::https://github.com/movinalot/azure.git//ad/azuread_group"

  #source = "../azure/ad/azuread_group"

  display_name       = each.value.display_name
  owners             = each.value.owners
  security_enabled   = each.value.security_enabled
  assignable_to_role = each.value.assignable_to_role
}

output "groups" {
  value = var.enable_module_output ? module.module_azuread_group[*] : null
}
