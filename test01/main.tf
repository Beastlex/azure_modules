provider "azurerm" {
  features {}
}

# Создаем RG
resource "azurerm_resource_group" "rg-demo" {
  name     = "rg-${var.postfix}-01"
  location = var.location
  tags = {
    "owner" = var.owner-tag
  }
}
