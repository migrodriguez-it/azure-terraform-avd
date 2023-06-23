##############################################
# TENANT ID
##############################################
variable "tenant_id" {
  default = "6a8e6d20-fdb6-4869-82b2-98890a7e60a2" # Tenant Test
}

##############################################
# SUBSCIPTION ID
##############################################
variable "subs_id" {
  default = "68230767-492f-4f64-934b-5a72cf53c0b8" # Tenant Test
}

##############################################
# CLIENT ID
##############################################
variable "client_id" {
  default = "18339f49-35c0-499b-9e18-ab52c32276b8" # Tennnt Test
}

##############################################
# SECRET ID
##############################################
variable "secret_id" {
  default = "BEv8Q~UGEKciY0oQR2BQhXn2JWS6aCGEOKllfc_q" # Tenant Test
}

##############################################
# RESOURCE GROUP NAME
##############################################
variable "rg_name" {
  type    = string
  default = "miguel_rodriguez"
}

##############################################
# HOST POOL
##############################################
variable "hostpool" {
  type    = string
  default = "AVD-HP"
}

##############################################
# CUSTOMER PREFIX
##############################################
variable "prefix" {
  type    = string
  default = "ausumcloud"
}

##############################################
# RESOURCES LOCATION
##############################################
variable "location" {
  type    = string
  default = "westeurope"
  #default = "eastus"
}

##############################################
# TIME ZONE
##############################################
variable "tmz" {
  type    = string
  default = "Romance Standard Time"
  #default = "US Eastern Standard Time"
}

##############################################
# LOAD BALANCER TYPE
##############################################
variable "lb_type" {
  type    = string
  default = "BreadthFirst" #[BreadthFirst DepthFirst]
}

##############################################
# HOSTPOOL TYPE
##############################################
variable "hp_type" {
  type    = string
  default = "Pooled" #[Pooled Personal]
}

##############################################
# MAX SESSIONS HOST POOL
##############################################
variable "session_max_hp" {
  default = 2
}

##############################################
# VIRTUAL MACHINES AVD NUMBER
##############################################
variable "vm_count" {
  default = 4
}

##############################################
# DOMAIN NAME
##############################################
variable "domain_name" {
  type = string
  #default = "ausum.cloud"
  default = "silicio14.co"
}

/*
##############################################
# DOMAIN NAME USER
##############################################
variable "domain_user" {
  type    = string
  default = "addadmin" # Do not include domain name as this is appended
}

##############################################
# DOMAIN PASSWORD
##############################################
variable "domain_password" {
  type      = string
  default   = "Mr19780206&$"
  sensitive = true
}
*/

##############################################
# VIRTUAL MACHINES SIZE
##############################################
variable "vm_size" {
  type = string
  #  default = "Standard_B4ms"
  default = "Standard_DS1_v2"
}

##############################################
# VITUAL MACHINES SKU
##############################################
variable "vm_sku" {
  type    = string
  default = "win10-21h2-avd-g2"
}

##############################################
# VITUAL MACHINES OFFER
##############################################
variable "vm_offer" {
  type    = string
  default = "Windows-10"
}

##############################################
# VITUAL MACHINES PUBLISHER
##############################################
variable "vm_publisher" {
  type    = string
  default = "MicrosoftWindowsDesktop"
}

##############################################
# VITUAL MACHINES OS TYPE
##############################################
variable "vm_os-type" {
  type    = string
  default = "Windows"
}

##############################################
# VITUAL MACHINES LOCAL ADMIN USER
##############################################
variable "local_admin_username" {
  type    = string
  default = "localadm"
}

/*
##############################################
# ADD ADMIN PASSWORD
##############################################
variable "admin_password" {
  type      = string
  default   = "Mr19780206&$"
  sensitive = true
}
*/

##############################################
# VIRTUAL DESKTOP DOMAIN USERS
##############################################
variable "avd_users" {
  default = [
    "miguel@silicio14.co"
  ]
}

##############################################
# AZUERE AD AVD GROUP
##############################################
variable "aad_group_name" {
  type    = string
  default = "AVDUsers"
}
