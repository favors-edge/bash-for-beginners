#Centralizing values like location and resource group name into variables makes future changes a one-line edit.
variable "location" {
    description = "Azure region for all resources"
    type = string
    default = "East US"
}

variable "resource_group_name" {
    description = "Name of the resource group"
    type = string
    default = "rg-hubspoke-dev"
}

variable "admin_username" {
    description = "Admin username for the web VM"
    type = string
    default = "azureuser"
}