##############################################
# TENANT ID
##############################################
variable "tenant_id" {
  default = ""
}

##############################################
# SUBSCIPTION ID
##############################################
variable "subs_id" {
  default = ""
}

##############################################
# CLIENT ID
##############################################
variable "client_id" {
  default = ""
}

##############################################
# SECRET ID
##############################################
variable "secret_id" {
  default = ""
}

/*
If the resource group already exists, you can use the following code:
##############################################
# RESOURCE GROUP NAME
##############################################
variable "rg_name" {
  type    = string
  default = ""
}
*/

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
  default = "silicio14"
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
  default = "Persistent" #[Persistent BreadthFirst DepthFirst]
}

##############################################
# HOSTPOOL TYPE
##############################################
variable "hp_type" {
  type    = string
  default = "Personal" #[Pooled Personal]
}

##############################################
# HOSTPOOL TYPE
##############################################
variable "personal_assignment" {
  type    = string
  default = "Direct" #[Direct Automatic]
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
  type    = string
  default = "silicio14.co"
}

/*
Use this code if you have a own domain controller 
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
  default   = ""
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
  default = "win10-22h2-avd-g2"
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
  default   = ""
  sensitive = true
}
*/

##############################################
# VIRTUAL DESKTOP DOMAIN USERS
##############################################
#Add the users that will be able to access the AVD
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
