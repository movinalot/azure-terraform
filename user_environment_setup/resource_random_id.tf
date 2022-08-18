resource "random_id" "id" {
  for_each = local.users

  keepers = {
    resource_group_name = format("%s", each.value.name)
  }

  byte_length = 4
}