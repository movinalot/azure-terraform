terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}