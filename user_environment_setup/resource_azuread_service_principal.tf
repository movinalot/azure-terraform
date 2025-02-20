resource "azuread_service_principal" "service_principal" {
  for_each = local.per_user_service_principal ? local.users : {}

  client_id                    = azuread_application.application[each.value.name].application_id
  app_role_assignment_required = false
  owners                       = [azuread_user.user[each.value.name].id]
}

output "service_principals" {
  value = azuread_service_principal.service_principal
}
