provider "azurerm" {
    features {}
}

# Create resource group
resource "azurerm_resource_group" "resource_group" {
    name = "rg-terraform-pract"
    loacation = "eastus"
}

# Create a Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = "terraform-pract-storage-6"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}