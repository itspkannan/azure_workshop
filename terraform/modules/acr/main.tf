resource "azurerm_container_registry" "acr" {
  name                     = var.acr_name
  location                 = var.location
  sku                      = "Basic"
  admin_enabled            = true
}
