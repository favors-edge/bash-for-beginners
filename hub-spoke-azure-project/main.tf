provider "azurerm" {
    features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
    name = "rg-terraform"
    location = "eastus"
}

# Create HUB + Spoke Virtual Networks
# Hub VNET
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Spoke VNET:Web
resource "azurerm_virtual_network" "spoke_web" {
  name                = "vnet-spoke-web-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

# Spoke VNET:App
resource "azurerm_virtual_network" "spoke_app" {
  name                = "vnet-spoke-app-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.2.0.0/16"]
}

# Spoke VNET:Storage
resource "azurerm_virtual_network" "spoke_storage" {
  name                = "vnet-spoke-storage-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.3.0.0/16"]
}

# Create subnets
# HUB subnet
resource "azurerm_subnet" "hub_subnet" {
  name                 = "hub-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Web spoke subnet
resource "azurerm_subnet" "web_subnet" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke_web.name
  address_prefixes     = ["10.1.1.0/24"]
}

# App spoke subnet
resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke_app.name
  address_prefixes     = ["10.2.1.0/24"]
}

# Storage spoke subnet (private endpoint lives here)
resource "azurerm_subnet" "storage_subnet" {
  name                 = "storage-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke_storage.name
  address_prefixes     = ["10.3.1.0/24"]
}

# Create VNET Peering (W/ HUB + EACH Spoke)
# Hub + Web Peering
resource "azurerm_virtual_network_peering" "hub_to_web" {
  name                      = "hub-to-web"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_web.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "web_to_hub" {
  name                      = "web-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_web.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = true
}

# Hub + App Peering
resource "azurerm_virtual_network_peering" "hub_to_app" {
  name                      = "hub-to-app"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_app.id
  allow_forwarded_traffic   = true
}
resource "azurerm_virtual_network_peering" "app_to_hub" {
  name                      = "app-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_app.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = true
}

# Hub + Storage Peering
resource "azurerm_virtual_network_peering" "hub_to_storage" {
  name                      = "hub-to-storage"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_storage.id
  allow_forwarded_traffic   = true
}
resource "azurerm_virtual_network_peering" "storage_to_hub" {
  name                      = "storage-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_storage.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = true
}

# Create NSG for Web subnet
resource "azurerm_network_security_group" "web_nsg" {
  name                = "nsg-web"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "web_assoc" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

# Create LINUX VM for (WEB SPOKE WORKLOAD)
resource "azurerm_network_interface" "web_nic" {
  name                = "nic-web"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "web_vm" {
  name                = "vm-web"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  admin_password      = "Password1234!"

  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.web_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Create Storage Account

resource "random_string" "storage_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "storage" {
  name                          = "sthubspoke${random_string.storage_suffix.result}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = eastus
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = false
}