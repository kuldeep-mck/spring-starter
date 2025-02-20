# main.tf

# Provider configuration for Azure
provider "azurerm" {
  features {}
}

# azureResourceGroup block: This file sets up the Azure infrastructure using Terraform.
# It configures the necessary resources such as Azure Resource Group, Virtual Network, Subnets, and more.
# It ensures these resources are managed and provisioned efficiently.

# Setting up the Azure Resource Group where all other resources will be placed.
# This is a logical container for resource management.
resource "azurerm_resource_group" "main" {
  name     = "example-resources"
  location = "West Europe"

  tags = {
    environment = "Terraform Demo"
  }
}

# Provision an Azure Virtual Network to enable communication between different Azure resources.
resource "azurerm_virtual_network" "main" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    environment = "Terraform Demo"
  }
}

# Create and manage subnets within the Virtual Network to segment and organize resources within the virtual network.
resource "azurerm_subnet" "internal" {
  name                 = "internal-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create and manage subnets within the Virtual Network to segment and organize resources within the virtual network.
resource "azurerm_subnet" "public" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# azureVM block: This script provisions Azure Virtual Machines and configures them with the necessary settings and parameters.

# Define and set up Azure Virtual Machines, including the specifications such as size, image, and authentication.
resource "azurerm_virtual_machine" "main" {
  name                  = "example-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "example-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "example-vm"
    admin_username = "adminuser"
    admin_password = "adminPassword123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Apply necessary configurations to the virtual machines such as network interfaces, public IPs, extensions, and more.
resource "azurerm_network_interface" "main" {
  name                = "example-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# azureStorage block: This section handles the creation of Azure Storage Accounts to manage and store data persistently.

# Set up Azure Storage Accounts that include configurations for type, replication strategy, and other settings.
resource "azurerm_storage_account" "main" {
  name                     = "examplestore"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Terraform Demo"
  }
}

# Apply specific settings and policies to manage storage effectively, such as access tiers, encryption, and network access rules.
resource "azurerm_storage_container" "main" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
