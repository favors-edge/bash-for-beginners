# Outputs print key values to your terminal after terraform apply, saving you from hunting through the Azure Portal.

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "web_vm_private_ip" {
  value = azurerm_network_interface.web_nic.private_ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "private_endpoint_ip" {
  value = azurerm_private_endpoint.storage_pe.private_service_connection[0].private_ip_address
}