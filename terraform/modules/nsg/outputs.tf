output "nsg_name" {
  value = azurerm_network_security_group.private_nsg.name
}

output "nsg_id" {
  value = azurerm_network_security_group.private_nsg.id
}

output "nsg_association_subnet_id" {
  value = azurerm_subnet_network_security_group_association.assoc.subnet_id
}
