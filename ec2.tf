provider "azurerm" {
  features {}
  client_id       = var.AZURE_CLIENT_ID
  client_secret   = var.AZURE_SECRET
  subscription_id = var.AZURE_SUBSCRIPTION_ID
  tenant_id       = var.AZURE_TENANT_ID
}

resource "azurerm_resource_group" "example" {
  name     = "myResourceGroup"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "example" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.example.location

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "myNIC"
  location            =
