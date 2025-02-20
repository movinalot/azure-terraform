resource "azuread_application" "application" {
  for_each = local.per_user_service_principal ? local.users : {}

  display_name     = format("%s-sp", each.value.name)
  owners           = [azuread_user.user[each.value.name].id]
  sign_in_audience = "AzureADMyOrg"

  feature_tags {
    enterprise = true
  }
}

output "applications" {
  value = var.enable_output ? azuread_application.application : null
}
