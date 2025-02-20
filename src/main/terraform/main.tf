provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name   = "example-resources"
    storage_account_name  = "examplestorageacc"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

variable "location" {
  description = "The Azure location where the resources will be deployed."
  type        = string
  default     = "West Europe"
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
  default     = "example-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "List of subnets to create within the virtual network."
  type        = map(object({ name = string, address_prefix = string }))
  default = {
    subnet1 = { name = "subnet1", address_prefix = "10.0.1.0/24" }
    subnet2 = { name = "subnet2", address_prefix = "10.0.2.0/24" }
  }
}

variable "nsg_rules" {
  description = "Network security group rules."
  type        = list(object({ name = string, priority = number, direction = string, access = string, protocol = string, source_port_range = string, destination_port_range = string, source_address_prefix = string, destination_address_prefix = string }))
  default = [
    { name = "allow_ssh", priority = 100, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "22", source_address_prefix = "*", destination_address_prefix = "*" },
    { name = "allow_http", priority = 200, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "80", source_address_prefix = "*", destination_address_prefix = "*" },
    { name = "allow_https", priority = 300, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "443", source_address_prefix = "*", destination_address_prefix = "*" }
  ]
}

variable "peer_vnet" {
  description = "Details of the virtual network to peer with."
  type        = object({ id = string, allow_virtual_network_access = bool, allow_forwarded_traffic = bool, allow_gateway_transit = bool, use_remote_gateways = bool })
  default = {
    id                         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/peer-resources/providers/Microsoft.Network/virtualNetworks/peer-vnet"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = false
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = "example-resources"
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = "example-resources"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "example-nsg"
  location            = var.location
  resource_group_name = "example-resources"

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_virtual_network_peering" "vnet_peering" {
  name                      = "example-vnet-peering"
  resource_group_name       = "example-resources"
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = var.peer_vnet.id
  allow_virtual_network_access = var.peer_vnet.allow_virtual_network_access
  allow_forwarded_traffic      = var.peer_vnet.allow_forwarded_traffic
  allow_gateway_transit        = var.peer_vnet.allow_gateway_transit
  use_remote_gateways          = var.peer_vnet.use_remote_gateways
}

resource "azurerm_virtual_network_gateway" "vnet_gateway" {
  name                = "example-vnet-gateway"
  location            = var.location
  resource_group_name = "example-resources"
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  sku                 = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "example-public-ip"
  resource_group_name = "example-resources"
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = "example-resources"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.255.0/27"]
}
