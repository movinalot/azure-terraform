resource "random_id" "id" {
  for_each = local.users

  keepers = {
    resource_group_name = format("%s_%s", each.value.name, local.resource_group_suffix)
  }

  byte_length = 4
}