locals {
  user_credentials_tmp = <<-EOT
%{for user in module.module_azurerm_bastion_host~}
%{if local.per_user_service_principal == true}
${format(
  "\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"",
  split("-", user["bastion_host"].resource_group_name)[0],
  var.user_password,
  user["bastion_host"].resource_group_name,
  user["bastion_host"].name,
  format("vm-bst-%s", split("-", user["bastion_host"].resource_group_name)[0]),
  azuread_service_principal.service_principal[split("-", user["bastion_host"].resource_group_name)[0]].application_id,
  azuread_application_password.application_password[split("-", user["bastion_host"].resource_group_name)[0]].value,
  data.azurerm_subscription.subscription.subscription_id,
  data.azurerm_subscription.subscription.tenant_id
  )}
%{endif}
%{if local.per_user_service_principal == false}
${format(
  "\"%s\",\"%s\"",
  user["user"].display_name,
  var.user_password
)}
%{endif}
%{endfor~}
EOT

user_credentials = replace(local.user_credentials_tmp, "/(?m)(?s)(^[\r\n])/", "")
}

resource "local_sensitive_file" "file" {
  filename = "${path.module}/user_credentials.csv"
  content  = local.user_credentials
}