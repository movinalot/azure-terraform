resource "azuread_application_password" "application_password" {
  for_each = local.per_user_service_principal ? local.users : {}

  application_object_id = azuread_application.application[each.value.name].object_id
}

output "application_passwords" {
  value     = var.enable_module_output ? azuread_application_password.application_password : null
  sensitive = true
}