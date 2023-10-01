module "module_azurerm_linux_virtual_machine" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true && user.bastion_host_type == "lin"
  } : {}

  source = "git::https://github.com/movinalot/azure.git//rm/azurerm_linux_virtual_machine"

  #source = "../azure/rm/azurerm_linux_virtual_machine"

  resource_group_name = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.name
  location            = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.location

  name = format("vm-b%s-%s", each.value.bastion_host_type, each.value.username)
  size = local.user_common["linux_vm_size"]

  network_interface_ids = [module.module_azurerm_network_interface[format("%s-%s-utility", each.value.username, each.value.suffix)].network_interface.id]

  admin_username = each.value.username
  admin_password = local.user_common["password"]
  computer_name  = format("vm-b%s-%s", each.value.bastion_host_type, each.value.username)

  disable_password_authentication = false

  os_disk_name                 = format("disk-os-%s-%s", each.value.bastion_host_type, each.value.username)
  os_disk_caching              = "ReadWrite"
  os_disk_storage_account_type = "Standard_LRS"

  allow_extension_operations = true

  storage_account_uri = null

  identity = "SystemAssigned"

  source_image_reference_publisher = "Canonical"
  source_image_reference_offer     = "UbuntuServer"
  source_image_reference_sku       = "18.04-LTS"
  source_image_reference_version   = "latest"
}

output "linux_virtual_machines" {
  value     = var.enable_module_output ? module.module_azurerm_linux_virtual_machine[*] : null
  sensitive = true
}