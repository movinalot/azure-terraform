locals {
  user_credentials_tmp = <<-EOT
%{for user in module.module_azuread_user~}
%{if local.per_user_service_principle == true}
${format(
  "\"%s\",\"%s\",\"%s\",\"%s\"",
  user["user"].display_name,
  var.user_password,
  azuread_service_principal.service_principal[user["user"].display_name].application_id,
  azuread_application_password.application_password[user["user"].display_name].value
  )}
%{endif}
%{if local.per_user_service_principle == false}
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