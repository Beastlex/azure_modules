resource "azurerm_virtual_network" "vnc-demo" {
  name                = "vnc-${var.postfix}-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-demo.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subn-demo" {
  name                 = "subn-${var.postfix}-01"
  resource_group_name  = azurerm_resource_group.rg-demo.name
  virtual_network_name = azurerm_virtual_network.vnc-demo.name
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "allow-ssh" {
  name                = "nsg-${var.postfix}-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-demo.name

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

