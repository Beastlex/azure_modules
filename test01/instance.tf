resource "azurerm_virtual_machine" "vm-demo" {
  name                  = "vm-${var.postfix}-01"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg-demo.name
  network_interface_ids = [azurerm_network_interface.if-demo.id]
  vm_size               = "Standard_A1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "mydisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vm-az-01"
    admin_username = "alex"
    admin_password = "dAsHj-k72egjdbal89"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("testkey.pub")
      path     = "/home/alex/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_network_interface" "if-demo" {
  name                      = "if-${var.postfix}-01"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg-demo.name

  ip_configuration {
    name                          = "instance1"
    subnet_id                     = azurerm_subnet.subn-demo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip-demo.id
  }
}

resource "azurerm_network_interface_security_group_association" "allow-ssh" {
  network_interface_id      = azurerm_network_interface.if-demo.id
  network_security_group_id = azurerm_network_security_group.allow-ssh.id
}

resource "azurerm_public_ip" "pubip-demo" {
    name                         = "pubip-demo"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg-demo.name
    allocation_method            = "Dynamic"
}
