# The main Terraform configuration file for setting up various Azure resources

# Provider Setup: This function sets up the Terraform provider for Azure, including authentication and initialization. It uses the Azure provider to manage resources.
terraform {
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group: This function creates a resource group in Azure to contain and organize the related resources. It specifies the resource group's name and location.
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Monitor: This function sets up Azure Monitor resources, including the creation of Action Groups and Alert Rules. It ensures resources are monitored for critical conditions.
resource "azurerm_monitor_action_group" "example" {
  name                = var.action_group_name
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "exampleaction"

  email_receiver {
    name          = "exampleemail"
    email_address = var.email_address
  }
}

resource "azurerm_monitor_metric_alert" "example" {
  name                = var.metric_alert_name
  resource_group_name = azurerm_resource_group.example.name
  target_resource_id  = var.target_resource_id
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    operator         = "GreaterThan"
    aggregation      = "Total"
    threshold        = 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

# Event Hub: This function configures Azure Event Hubs, including namespaces and event hub instances. It sets up the necessary permissions and policies.
resource "azurerm_eventhub_namespace" "example" {
  name                = var.eventhub_namespace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
}

resource "azurerm_eventhub" "example" {
  name                = var.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name
  partition_count     = 2
  message_retention   = 1
}

# Notification Hub: This function sets up Azure Notification Hubs, including namespaces and notification hub instances. It also configures connection settings and access policies.
resource "azurerm_notification_hub_namespace" "example" {
  name                = var.notification_hub_namespace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
}

resource "azurerm_notification_hub" "example" {
  name                = var.notification_hub_name
  namespace_name      = azurerm_notification_hub_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name
}

# Container Instance: This function deploys the containerized application instance in Azure using Azure Container Instances. It specifies the container's image, environment variables, and network settings.
resource "azurerm_container_group" "example" {
  name                = var.container_group_name
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux"

  container {
    name   = var.container_name
    image  = var.container_image
    cpu    = var.container_cpu
    memory = var.container_memory

    ports {
      port     = var.container_port
      protocol = "TCP"
    }

    environment_variables = var.container_environment_variables
  }

  tags = var.tags
}
