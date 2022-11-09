resource "azuread_application" "application" {
  for_each = local.per_user_service_principal ? local.users : {}

  display_name     = format("%s-sp", each.value.name)
  owners           = [module.module_azuread_user[each.value.name].user.id]
  sign_in_audience = "AzureADMyOrg"

  feature_tags {
    enterprise = true
  }
}

output "applications" {
  value = var.enable_module_output ? azuread_application.application : null
}