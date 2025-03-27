resource "azurerm_lb" "lb" {
  for_each = local.lbs

  resource_group_name        = each.value.resource_group_name
  location                   = each.value.location

  name                       = each.value.name
  sku                        = each.value.sku

  dynamic "frontend_ip_configuration" {
    for_each = [
      for fe_ip in each.value.frontend_ip_configurations : fe_ip
      if lookup(fe_ip, "public_ip_address_id", null) != null
    ]
    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id
    }
  }
  dynamic "frontend_ip_configuration" {
    for_each = [
      for fe_ip in each.value.frontend_ip_configurations : fe_ip
      if lookup(fe_ip, "private_ip_address", null) != null
    ]
    content {
      name                          = frontend_ip_configuration.value.name
      subnet_id                     = frontend_ip_configuration.value.subnet_id
      private_ip_address            = frontend_ip_configuration.value.private_ip_address
      private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address_allocation
      private_ip_address_version    = frontend_ip_configuration.value.private_ip_address_version
    }
  }
}

output "lbs" {
  value = var.enable_output ? azurerm_lb.lb[*] : null
}
