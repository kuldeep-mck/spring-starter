terraform {
  # Terraform settings
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.44"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West US"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestoracc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "example-appservice"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
  site_config {
    dotnet_framework_version = "v4.0"
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.example.name
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.example.name
}

output "app_service_plan_id" {
  description = "The id of the App Service plan"
  value       = azurerm_app_service_plan.example.id
}

output "app_service_name" {
  description = "The name of the App Service"
  value       = azurerm_app_service.example.name
}

output "app_service_default_hostname" {
  description = "The default hostname of the App Service"
  value       = azurerm_app_service.example.default_site_hostname
}
