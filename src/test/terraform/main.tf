provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "testResourceGroup"
  location = "East US"
}

resource "azurerm_virtual_network" "test" {
  name                = "testVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_subnet" "test" {
  name                 = "testSubnet"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "test" {
  name                = "testNetworkSecurityGroup"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_virtual_network_peering" "test" {
  name                          = "testVNetPeering"
  resource_group_name           = azurerm_resource_group.test.name
  virtual_network_name          = azurerm_virtual_network.test.name
  remote_virtual_network_id     = "<remote_vnet_id>"
  allow_forwarded_traffic       = true
  allow_gateway_transit         = false
  use_remote_gateways           = false
}

resource "azurerm_virtual_network_gateway" "test" {
  name                = "testVNetGateway"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "Standard"
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "<public_ip_address_id>"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.test.id
  }
}

module "test_validation" {
  source = "path_to_module/mocked_script"
  vnet_address_spaces = [azurerm_virtual_network.test.address_space]
}
