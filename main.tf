##############################################
# RESOURCE GROUP
##############################################
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}_avd_rg"
  location = var.location
}

##############################################
# STORAGE ACCOUNT
##############################################
resource "azurerm_storage_account" "sa" {
  name                     = "${var.prefix}avdsa"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Premium"
  account_replication_type = "LRS"
  #  account_kind             = "FileStorage"
}

##############################################
# STORAGE ACCOUNT CONTAINER
##############################################
resource "azurerm_storage_container" "sa_con" {
  name                  = "${var.prefix}vhds"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

##############################################
# STORAGE ACCOUNT FILESTORAGE
##############################################
resource "azurerm_storage_account" "sa-fs" {
  name                     = "${var.prefix}avdfs"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"
}

##############################################
# ROLE ASSINGMENT
##############################################
## Azure built-in roles
data "azurerm_role_definition" "st-role" {
  name = "Storage File Data SMB Share Contributor"
}

resource "azurerm_role_assignment" "af_role" {
  scope              = azurerm_storage_account.sa.id
  role_definition_id = data.azurerm_role_definition.st-role.id
  principal_id       = azuread_group.aad_group.id
}
