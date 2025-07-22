output "load_balancer_name" {
  value = azurerm_lb.lb.name
}

output "load_balancer_id" {
  value = azurerm_lb.lb.id
}

output "public_ip_address" {
  value = azurerm_public_ip.lb_ip.ip_address
}

output "frontend_ip_configuration_id" {
  value = azurerm_lb.lb.frontend_ip_configuration[0].id
}

output "frontend_ip_configuration_name" {
  value = azurerm_lb.lb.frontend_ip_configuration[0].name
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.backend.id
}

output "lb_rule_id" {
  value = azurerm_lb_rule.http.id
}
