resource "random_id" "id" {
  for_each = local.users

  keepers = {
    resource_group_name = format("%s%s", each.value.name, local.user_common["display_name_ext"])
  }

  byte_length = 4
}