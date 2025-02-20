resource "azuread_group_member" "group_member" {
  for_each = local.users

  group_object_id  = azuread_group.group[each.value.group_display_name].id
  member_object_id = azuread_user.user[each.value.name].id
}

output "group_members" {
  value = var.enable_output ? azuread_group_member.group_member[*] : null
}
