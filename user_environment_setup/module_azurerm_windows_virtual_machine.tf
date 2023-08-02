module "module_azurerm_windows_virtual_machine" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true && user.bastion_host_type == "win"
  } : {}

  source = "../azure/rm/azurerm_windows_virtual_machine"

  resource_group_name = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.name
  location            = module.module_azurerm_resource_group[each.value.resource_group_name].resource_group.location

  name = format("vm-b%s-%s", each.value.bastion_host_type, each.value.username)
  size = local.user_common["windows_vm_size"]

  network_interface_ids = [module.module_azurerm_network_interface[format("%s-%s-utility", each.value.username, each.value.suffix)].network_interface.id]

  admin_username = each.value.username
  admin_password = local.user_common["password"]
  computer_name  = format("vm-b%s-%s", each.value.bastion_host_type, each.value.username)

  os_disk_name                 = format("disk-os-%s-%s", each.value.bastion_host_type, each.value.username)
  os_disk_caching              = "ReadWrite"
  os_disk_storage_account_type = "Standard_LRS"

  allow_extension_operations = true

  storage_account_uri = null

  identity = "SystemAssigned"

  source_image_reference_publisher = "MicrosoftWindowsDesktop"
  source_image_reference_offer     = "Windows-10"
  source_image_reference_sku       = "win10-22h2-pro-g2"
  source_image_reference_version   = "latest"

  custom_data = filebase64("./scripts/winclient_init.ps1")

  license_type = "Windows_Client"
}

resource "azurerm_virtual_machine_extension" "virtual_machine_extension" {
  for_each = local.bastion_host_support ? {
    for name, user in local.user_resource_groups_map : name => user
    if user.bastion == true && user.bastion_host_type == "win"
  } : {}

  name                 = "cloudinit"
  virtual_machine_id   = module.module_azurerm_windows_virtual_machine[each.value.resource_group_name].windows_virtual_machine.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"cp c:/azuredata/customdata.bin c:/azuredata/forticlientinstall.ps1; c:/azuredata/forticlientinstall.ps1\""
    }
    SETTINGS
}

output "windows_virtual_machines" {
  value     = var.enable_module_output ? module.module_azurerm_windows_virtual_machine[*] : null
  sensitive = true
}