/*
resource "random_uuid" "avd_uuid" {
}

data "azurerm_subscription" "subs" {
}

##############################################
# ROLE DEFINITION
##############################################
resource "azurerm_role_definition" "roledef" {
  name        = "AVD-AutoScale"
  scope       = var.subs_id
  description = "AVD AutoScale Role"
  permissions {
    actions = [
      "Microsoft.Insights/eventtypes/values/read",
      "Microsoft.Compute/virtualMachines/deallocate/action",
      "Microsoft.Compute/virtualMachines/restart/action",
      "Microsoft.Compute/virtualMachines/powerOff/action",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.DesktopVirtualization/hostpools/read",
      "Microsoft.DesktopVirtualization/hostpools/write",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/read",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/write",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/delete",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/read",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/sendMessage/action",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/read"
    ]
    not_actions = []
  }
  assignable_scopes = [
    var.subs_id,
  ]
}
data "azuread_service_principal" "avd_asp" {
  display_name = "Terraform"
}

data "azuread_client_config" "current" {}

resource "azuread_application" "az_app" {
  display_name = "AVD APP"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "avd_sp" {
  application_id               = azuread_application.az_app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

##############################################
# AZURE ROLE ASSIGNMENT
##############################################
resource "azurerm_role_assignment" "role" {
  name                             = random_uuid.avd_uuid.result
  scope                            = data.azurerm_subscription.subs.id
  role_definition_id               = azurerm_role_definition.roledef.role_definition_resource_id
  principal_id                     = data.azuread_service_principal.avd_asp.id
  skip_service_principal_aad_check = true
}

##############################################
# SCALING PLAN
##############################################
resource "azurerm_virtual_desktop_scaling_plan" "avd_scp" {
  name     = "AusumAVDScallingPlan"
  location = var.location
  #  resource_group_name      = var.rg_name
  resource_group_name = azurerm_resource_group.rg.name
  time_zone           = var.tmz
  schedule {
    name                                 = "ScalinPlanWeek"
    days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    ramp_up_start_time                   = "05:00"
    ramp_up_load_balancing_algorithm     = "BreadthFirst"
    ramp_up_minimum_hosts_percent        = 20
    ramp_up_capacity_threshold_percent   = 80
    peak_start_time                      = "06:00"
    peak_load_balancing_algorithm        = "BreadthFirst"
    ramp_down_start_time                 = "22:00"
    ramp_down_load_balancing_algorithm   = "DepthFirst"
    ramp_down_minimum_hosts_percent      = 20
    ramp_down_force_logoff_users         = true
    ramp_down_wait_time_minutes          = 15
    ramp_down_notification_message       = "You will be logged off in 15 min. Please log out, make sure to save your work and log in to continue working on another server."
    ramp_down_capacity_threshold_percent = 90
    ramp_down_stop_hosts_when            = "ZeroSessions"
    off_peak_start_time                  = "23:00"
    off_peak_load_balancing_algorithm    = "DepthFirst"
  }
  host_pool {
    hostpool_id          = azurerm_virtual_desktop_host_pool.hp.id
    scaling_plan_enabled = true
  }
}
*/