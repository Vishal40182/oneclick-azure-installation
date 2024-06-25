# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.84.0"
#     }
#     azapi = {
#       source = "Azure/azapi"
#     }
#   }
# #   backend "azurerm" {
# #   }
# }

# # Configure the Microsoft Azure Provider
# provider "azurerm" {
#   features {
#     key_vault {
#       purge_soft_delete_on_destroy    = true
#       recover_soft_deleted_key_vaults = true
#     }
#   }
#   subscription_id = var.subscriptionID
#   tenant_id       = var.tenantid
# #   client_id       = var.clientid
# #   client_secret   = var.clientsecret
# }
# provider "azapi" {
#   subscription_id = var.subscriptionID
#   tenant_id       = var.tenantid
# #   client_id       = var.clientid
# #   client_secret   = var.clientsecret
# }
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.96.0"
    }
  }
}
provider "azurerm" {
  features {}
}