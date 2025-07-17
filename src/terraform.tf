terraform {
  required_version = "~> 1.12.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.36.0"
    }
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~> 3.1"
    # }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  storage_use_azuread = true
  subscription_id     = local.subscription_id
}

provider "azurerm" {
  alias           = "dns_subscription"
  subscription_id = var.dns_subscription_id
  features {}
}
