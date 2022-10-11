resource "azuread_service_principal" "service_principal" {
  for_each = local.per_user_service_principle ? local.users : {}

  application_id               = azuread_application.application[each.value.name].application_id
  app_role_assignment_required = false
  owners                       = [module.module_azuread_user[each.value.name].user.id]
}

output "service_principals" {
  value = azuread_service_principal.service_principal
}

output "service_principals_csv" {
  value = var.enable_module_output ? [
    for service_principal in azuread_service_principal.service_principal : 
    format(
      "%s,%s,%s,%s",
      split("-",service_principal.display_name)[0],
      var.user_password ,service_principal.application_id,
      azuread_application_password.application_password[split("-",service_principal.display_name)[0]].value
    )
  ] : null
  sensitive = true
}
