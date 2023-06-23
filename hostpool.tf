##############################################
# WORKSPACE
##############################################
resource "azurerm_virtual_desktop_workspace" "ws" {
  name                = "${var.prefix}-avd-ws"
  resource_group_name = var.rg_name
  #resource_group_name = azurerm_resource_group.rg.name
  location = var.location
}

##############################################
# HOST POOL
##############################################
resource "azurerm_virtual_desktop_host_pool" "hp" {
  #resource_group_name = var.rg_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  name                  = "${var.prefix}-avd-hp"
  friendly_name         = var.hostpool
  validate_environment  = true
  custom_rdp_properties = "audiocapturemode:i:1;audiomode:i:0;targetisaadjoined:i:1;enablerdsaadauth:i:1;"
  type                  = var.hp_type
  #maximum_sessions_allowed         = var.session_max_hp
  load_balancer_type               = var.lb_type
  start_vm_on_connect              = true
  personal_desktop_assignment_type = var.personal_assignment
  scheduled_agent_updates {
    enabled = true
    schedule {
      day_of_week = "Sunday"
      hour_of_day = 2
    }
  }
}

##############################################
# TIME ROTATION
##############################################
resource "time_rotating" "avd_token" {
  rotation_days = 30
}

##############################################
# REGSITRATION INFO
##############################################
resource "azurerm_virtual_desktop_host_pool_registration_info" "reginfo" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.hp.id
  expiration_date = time_rotating.avd_token.rotation_rfc3339
}

##############################################
# DAG
##############################################
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name = var.rg_name
  #resource_group_name = azurerm_resource_group.rg.name
  host_pool_id = azurerm_virtual_desktop_host_pool.hp.id
  location     = var.location
  type         = "Desktop"
  name         = "${var.prefix}-avd-dag"
  depends_on   = [azurerm_virtual_desktop_host_pool.hp, azurerm_virtual_desktop_workspace.ws]
}
##############################################
# WORKSPACE AND DAG
##############################################
resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.ws.id
}
