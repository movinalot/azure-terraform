resource "azuread_service_principal" "service_principal" {
  for_each = local.per_user_service_principle ? local.users : {}

  application_id               = azuread_application.application[each.value.name].application_id
  app_role_assignment_required = false
  owners                       = [module.module_azuread_user[each.value.name].user.id]
}

output "service_principals" {
  value = azuread_service_principal.service_principal
}
