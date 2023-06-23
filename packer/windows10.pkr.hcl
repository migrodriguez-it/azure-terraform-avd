packer {
  required_plugins {
    azure = {
      version = "1.0.8"
      source  = "github.com/hashicorp/azure"
    }
    windows-update = {
      version = "0.14.1"
      source  = "github.com/rgl/windows-update"
    }
  }
}

variable "ami_name" {
  type    = string
  default = ""
}

variable "client_id" {
  type    = string
  default = ""
}

variable "client_secret" {
  type    = string
  default = ""
}

variable "subscription_id" {
  type    = string
  default = ""
}

variable "tenant_id" {
  type    = string
  default = ""
}

variable "avd_rg_name" {
  type    = string
  default = ""
}

variable "scripts_path" {
  type    = string
  default = "scripts"
}

source "azure-arm" "avd_w10_hardened" {
  build_resource_group_name         = "${var.avd_rg_name}"
  client_id                         = "${var.client_id}"
  client_secret                     = "${var.client_secret}"
  subscription_id                   = "${var.subscription_id}"
  tenant_id                         = "${var.tenant_id}"
  communicator                      = "winrm"
  image_offer                       = "Windows-10"
  image_publisher                   = "MicrosoftWindowsDesktop"
  image_sku                         = "win10-22h2-avd-g2"
  managed_image_name                = "${var.ami_name}"
  managed_image_resource_group_name = "${var.avd_rg_name}"
  os_type                           = "Windows"

  vm_size        = "Standard_B2ms"
  winrm_insecure = true
  winrm_timeout  = "5m"
  winrm_use_ssl  = true
  winrm_username = "packer"
}

build {
  sources = ["source.azure-arm.avd_w10_hardened"]

  # Install Choco & Packages
  provisioner "powershell" {
    script = "${var.scripts_path}/chocolatey.ps1"
  }

  #Configure system and permissions
  provisioner "powershell" {
    script = "${var.scripts_path}/configure.ps1"
  }

  #Windows Update
  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      "include:$true",
    ]
    update_limit = 25
  }
  #sysprep
  provisioner "powershell" {
    script = "${var.scripts_path}/sysprepw10.ps1"
  }

}