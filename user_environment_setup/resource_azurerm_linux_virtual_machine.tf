resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {

  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true && user.bastion_host_type == "lin"
  } : {}

  resource_group_name = azurerm_resource_group.resource_group[each.value.resource_group_name].name
  location            = azurerm_resource_group.resource_group[each.value.resource_group_name].location

  name = format("vm-b%s-%s", each.value.bastion_host_type, each.value.username)
  size = local.user_common["linux_vm_size"]

  network_interface_ids = [azurerm_network_interface.network_interface[format("%s-%s-utility", each.value.username, each.value.suffix)].id]

  admin_username = each.value.username
  admin_password = local.user_common["password"]
  computer_name  = format("vm-b%s-%s", each.value.bastion_host_type, each.value.username)

  disable_password_authentication = false

  os_disk {
    name                 = format("disk-os-%s-%s", each.value.bastion_host_type, each.value.username)
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  allow_extension_operations = true

  boot_diagnostics {
    storage_account_uri = null
  }
  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

output "linux_virtual_machines" {
  value     = var.enable_output ? azurerm_linux_virtual_machine.linux_virtual_machine[*] : null
  sensitive = true
}
