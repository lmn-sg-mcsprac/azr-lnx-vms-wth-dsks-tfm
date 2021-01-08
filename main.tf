terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.39.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "lmnapacops"
    container_name       = "tfstates"
    key                  = "azure/hep/terraform.tfstate"
    resource_group_name  = "lmn-sg-ops-rg"
  }
}

provider "azurerm" {
  features {}
}

