locals {
  user_credentials_tmp = <<-EOT
%{if local.bastion_host_support == true}
%{for user in local.user_resource_groups_subnets_map~}
%{if local.per_user_service_principal == true}
${format(
  "\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"",
  split("-", user.resource_group_name)[0],
  var.user_password,
  user.resource_group_name,
  user.username,
  format("vm-b%s-%s", split("-", user.username)[1], split("-", user.resource_group_name)[0]),
  azuread_service_principal.service_principal[split("-", user.resource_group_name)[0]].object_id,
  azuread_application_password.application_password[split("-", user.resource_group_name)[0]].value,
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
%{endif}
%{if local.bastion_host_support == false}
%{for user in azuread_user.user~}
%{if local.per_user_service_principal == true}
${format(
  "\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"",
  user.display_name,
  var.user_password,
  data.azurerm_subscription.subscription.tenant_id,
  data.azurerm_subscription.subscription.subscription_id,
  azuread_service_principal.service_principal[user.display_name].object_id,
  azuread_application_password.application_password[user.display_name].value
  )}
%{endif}
%{if local.per_user_service_principal == false}
${format(
  "\"%s\",\"%s\"",
  user.display_name,
  var.user_password
)}
%{endif}
%{endfor~}
%{endif}
EOT

user_credentials = replace(local.user_credentials_tmp, "/(?m)(?s)(^[\r\n])/", "")
}

resource "local_sensitive_file" "file" {
  filename = "${path.module}/${terraform.workspace}_credentials.csv"
  content  = local.user_credentials
}
