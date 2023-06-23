
##############################################
# LOCALS INFO
##############################################
locals {
  registration_token = azurerm_virtual_desktop_host_pool_registration_info.reginfo.token # REGISTRATION TOKEN INFO
  shutdown_command   = "shutdown -r -t 10"
  exit_code_hack     = "exit 0"
  commandtorun       = "New-Item -Path HKLM:/SOFTWARE/Microsoft/RDInfraAgent/AADJPrivate"
  powershell_command = "${local.commandtorun}; ${local.shutdown_command}; ${local.exit_code_hack}"
}

##############################################
# LOCAL ADMIN PASSWORD
##############################################
resource "random_string" "AVD_local_password" {
  count            = var.vm_count
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

##############################################
# NETWORK INTERFACES
##############################################
resource "azurerm_network_interface" "avd_vm_nic" {
  count = var.vm_count
  name  = "${var.prefix}-${count.index + 1}-nic"
  #resource_group_name = var.rg_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  ip_configuration {
    name                          = "nic${count.index + 1}_config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}
/*
If you have a custom image from a gallery, you can use the following code to get the image id:
##############################################
# IMAGE REFERENCE
##############################################
data "azurerm_image" "main" {
  name                = "WindowsSupportImage_wvd-1.0.0"
  resource_group_name = azurerm_resource_group.rg.name
  #resource_group_name      = var.rg_name
}

##############################################
# IMAGE ID
##############################################
output "image_id" {
  value = "/subscriptions/68230767-492f-4f64-934b-5a72cf53c0b8/resourceGroups/silicio14co_avd_rg/providers/Microsoft.Compute/images/WindowsSupportImage_wvd-1.0.0"
}

##############################################
# VIRTUAL MACHINES FROM IMAGE
##############################################
resource "azurerm_virtual_machine" "avd_ivm" {
  count = var.vm_count
  name  = "${var.prefix}-${count.index + 1}"
  #  resource_group_name      = var.rg_name
  resource_group_name              = azurerm_resource_group.rg.name
  location                         = var.location
  vm_size                          = var.vm_size
  network_interface_ids            = ["${azurerm_network_interface.avd_vm_nic.*.id[count.index]}"]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = data.azurerm_image.main.id
  }

  storage_os_disk {
    name              = "${lower(var.prefix)}-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.prefix}-${count.index + 1}"
    admin_username = var.local_admin_username
    admin_password = random_string.AVD_local_password[count.index].result
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  depends_on = [
    azurerm_network_interface.avd_vm_nic
  ]
}

##############################################
# VM IMAGE EXTENSIONS HOST SESSION
##############################################
resource "azurerm_virtual_machine_extension" "avd_sh" {
  depends_on = [
    azurerm_virtual_machine.avd_ivm
  ]
  count                = var.vm_count
  name                 = "${var.prefix}${count.index + 1}-avd_dsc"
  virtual_machine_id   = azurerm_virtual_machine.avd_ivm.*.id[count.index]
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"

  settings = <<-SETTINGS
        {
            "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
            "ConfigurationFunction": "Configuration.ps1\\AddSessionHost",
            "Properties" : {
            "hostPoolName" : "${azurerm_virtual_desktop_host_pool.hp.name}",
            "aadJoin": true
            }
        }
    SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "properties": {
        "registrationInfoToken": "${local.registration_token}"
        }
    }
    PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [tags]
  }
}

##############################################
# VM IMAGE EXTENSIONS AZURE DOMAIN
##############################################
resource "azurerm_virtual_machine_extension" "avd_aad" {
  depends_on = [
    azurerm_virtual_machine.avd_ivm
  ]
  count                = var.vm_count
  name                 = "${var.prefix}${count.index + 1}-avd_domain"
  virtual_machine_id   = azurerm_virtual_machine.avd_ivm.*.id[count.index]
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.0"

  settings = <<SETTINGS
    {
        "Name": "silicio14co.onmicrosoft.com",
        "User": "silicio14co.onmicrosoft.com\\addadmin",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "Password": "${var.admin_password}"
    }
PROTECTED_SETTINGS
}

*/

##############################################
# VIRTUAL MACHINES
##############################################
resource "azurerm_windows_virtual_machine" "avd_vm" {
  depends_on = [
    azurerm_network_interface.avd_vm_nic,
    azurerm_route_table.avdroute
  ]
  count = var.vm_count
  name  = "${var.prefix}-${count.index + 1}"
  #resource_group_name = var.rg_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.avd_vm_nic.*.id[count.index]}"]
  provision_vm_agent    = true
  admin_username        = var.local_admin_username
  admin_password        = random_string.AVD_local_password[count.index].result
  computer_name         = "${var.prefix}-${count.index + 1}"
  timezone              = var.tmz


  os_disk {
    name                 = "${lower(var.prefix)}-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}

##############################################
# VIRTUAL MACHINES EXTENSIONS AZURE AD
##############################################
resource "azurerm_virtual_machine_extension" "avd_aad" {
  depends_on = [
    azurerm_windows_virtual_machine.avd_vm,
    azurerm_virtual_machine_extension.avd_sh
  ]
  count                      = var.vm_count
  name                       = "${var.prefix}${count.index + 1}-avd_domain"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  auto_upgrade_minor_version = true
  type_handler_version       = "1.0"
}


##############################################
# VIRTUAL MACHINES EXTENSIONS HOST SESSION
##############################################
resource "azurerm_virtual_machine_extension" "avd_sh" {
  depends_on = [
    azurerm_windows_virtual_machine.avd_vm,
    azurerm_virtual_desktop_host_pool.hp
  ]
  count                = var.vm_count
  name                 = "${var.prefix}${count.index + 1}-avd_dsc"
  virtual_machine_id   = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"

  settings = <<-SETTINGS
        {
            "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
            "ConfigurationFunction": "Configuration.ps1\\AddSessionHost",
            "Properties" : {
            "hostPoolName" : "${azurerm_virtual_desktop_host_pool.hp.name}",
            "aadJoin": true
            }
        }
    SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "properties": {
        "registrationInfoToken": "${local.registration_token}"
        }
    }
    PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_virtual_machine_extension" "addaadjprivate" {
  depends_on = [
    azurerm_virtual_machine_extension.avd_aad
  ]
  count                = var.vm_count
  name                 = "AADJPRIVATE"
  virtual_machine_id   = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }
SETTINGS
}

##############################################
# VM SHUTDOWN SCHEDULE
##############################################
resource "azurerm_dev_test_global_vm_shutdown_schedule" "avd_sessionhost" {
  for_each           = toset(var.avd_desktop_user_list)
  virtual_machine_id = azurerm_windows_virtual_machine.avd_sessionhost[each.key].id
  location           = azurerm_resource_group.avd.location
  enabled            = true

  daily_recurrence_time = "2300"
  timezone              = var.tmz

  notification_settings {
    enabled = false
  }

  lifecycle {
    ignore_changes = [tags]
  }
}