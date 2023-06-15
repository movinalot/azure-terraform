module "module_azurerm_windows_virtual_machine" {
  for_each = local.bastion_host_support && local.bastion_host_type == "windows" ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true
  } : {}

  source = "../azure/rm/azurerm_windows_virtual_machine"

  resource_group_name = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.name
  location            = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.location

  name = format("vm-bst-%s", each.value.username)
  size = local.user_common["windows_vm_size"]

  network_interface_ids = [module.module_azurerm_network_interface[format("%s-%s-utility", each.value.username, each.value.suffix)].network_interface.id]

  admin_username = each.value.username
  admin_password = local.user_common["password"]
  computer_name  = format("vm-bst-%s", each.value.username)

  os_disk_name                 = format("disk-os-win-%s", each.value.username)
  os_disk_caching              = "ReadWrite"
  os_disk_storage_account_type = "Standard_LRS"

  allow_extension_operations = true

  storage_account_uri = null

  identity = "SystemAssigned"

  source_image_reference_publisher = "MicrosoftWindowsDesktop"
  source_image_reference_offer     = "Windows-10"
  source_image_reference_sku       = "win10-22h2-pro-g2"
  source_image_reference_version   = "latest"

  license_type = "Windows_Client"
}

output "windows_virtual_machines" {
  value     = var.enable_module_output ? module.module_azurerm_windows_virtual_machine[*] : null
  sensitive = true
}