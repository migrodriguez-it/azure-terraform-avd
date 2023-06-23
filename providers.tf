terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "azuread" {
  client_id     = var.client_id
  client_secret = var.secret_id
  tenant_id     = var.tenant_id
}


provider "azurerm" {
  features {}

  client_id                  = var.client_id
  client_secret              = var.secret_id
  tenant_id                  = var.tenant_id
  subscription_id            = var.subs_id
  skip_provider_registration = true
}
