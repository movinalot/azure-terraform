terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azuread" {
}

provider "azurerm" {
  features {}
}