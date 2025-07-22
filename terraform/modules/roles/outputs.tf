output "deployer_role_name" {
  description = "Name of the custom deployer role"
  value       = azurerm_role_definition.deployer.name
}

output "deployer_role_id" {
  description = "ID of the custom deployer role definition"
  value       = azurerm_role_definition.deployer.role_definition_resource_id
}

output "developer_role_name" {
  description = "Name of the custom developer role"
  value       = azurerm_role_definition.developer.name
}

output "developer_role_id" {
  description = "ID of the custom developer role definition"
  value       = azurerm_role_definition.developer.role_definition_resource_id
}
