
##############################################
# AD AZURE USER
##############################################
data "azuread_user" "aad_user" {
  for_each            = toset(var.avd_users)
  user_principal_name = format("%s", each.key)
}

##############################################
# AD AZURE ROLE DEFINITION USER
##############################################
data "azurerm_role_definition" "vm_user_login" {
  name = "Virtual Machine User Login"
}

##############################################
# AD AZURE ROLE DEFINITION DESKTOP
##############################################
data "azurerm_role_definition" "az_role" { # access an existing built-in role
  name = "Desktop Virtualization User"
}

##############################################
# AD AZURE GROUP
##############################################
resource "azuread_group" "aad_group" {
  display_name     = var.aad_group_name
  security_enabled = true
}

##############################################
# AD AZURE MEMBER
##############################################
resource "azuread_group_member" "aad_group_member" {
  for_each         = data.azuread_user.aad_user
  group_object_id  = azuread_group.aad_group.id
  member_object_id = each.value["id"]
}

##############################################
# AD AZURE ROLE ASSIGNMENT USER
##############################################
resource "azurerm_role_assignment" "vm_user_role" {
  #scope              = azurerm_resource_group.rg.id
  scope              = "/subscriptions/1b023971-4d9e-4b17-b351-b46e3058bac2/resourceGroups/miguel_rodriguez"
  role_definition_id = data.azurerm_role_definition.vm_user_login.id
  principal_id       = azuread_group.aad_group.id
}

##############################################
# AD AZURE ROLE ASSIGNMENT DESKTOP
##############################################
resource "azurerm_role_assignment" "az_role" {
  scope              = azurerm_virtual_desktop_application_group.dag.id
  role_definition_id = data.azurerm_role_definition.az_role.id
  principal_id       = azuread_group.aad_group.id
}

# PowerOn on session start
##############################################
# POWERON ROLE DEFINITION
##############################################
data "azurerm_role_definition" "poweron" {
  name  = "Desktop Virtualization Power On Contributor"
  scope = data.azurerm_subscription.subs.id
}
data "azuread_service_principal" "poweron" {
  display_name = "Terraform"
}
resource "azurerm_role_assignment" "poweron" {
  scope              = azurerm_resource_group.avd.id
  role_definition_id = data.azurerm_role_definition.poweron.id
  principal_id       = data.azuread_service_principal.poweron.id
}
