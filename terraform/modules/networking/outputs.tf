output "vnet_public_name" {
  value = azurerm_virtual_network.vnet_public.name
}

output "vnet_private_name" {
  value = azurerm_virtual_network.vnet_private.name
}

output "subnet_lb_id" {
  value = azurerm_subnet.subnet_lb.id
}

output "subnet_app_id" {
  value = azurerm_subnet.subnet_app.id
}
