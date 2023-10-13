# Define provider configuration for Azure
provider "azurerm" {
  features {}
  client_id       = "80016b05-b0ca-4a8e-b5a9-39b5b70a5153"
  client_secret   = "f0fcaf35-a56d-4998-be7b-b712432bec59"
  subscription_id = "209801ee-166f-436c-93e4-9327ecbc3b82"
  tenant_id       = "c367e5f6-985f-4a71-860b-bced391d356c"
}

# Define variables
variable "vm_name" {
  description = "Name for the Azure VM"
  default     = "myVM"
}

variable "location" {
  description = "Azure region for resource deployment"
  default     = "East US"
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "myResourceGroup"
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create a subnet
resource "azurerm_subnet" "example" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "example" {
  name                = "myPublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

# Create a network security group with an inbound rule for SSH
resource "azurerm_network_security_group" "example" {
  name                = "myNetworkSecurityGroup"
  location            = var.location

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

# Create a network interface
resource "azurerm_network_interface" "example" {
  name                = "myNIC"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create an Ubuntu Linux VM
resource "azurerm_linux_virtual_machine" "example" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  disable_password_authentication = true

  image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

# Output the public IP address of the VM
output "public_ip" {
  value = azurerm_public_ip.example.ip_address
}
