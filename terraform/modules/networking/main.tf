resource "azurerm_virtual_network" "vnet_public" {
  name                = "vnet-public"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet_lb" {
  name                 = "subnet-lb"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_public.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network" "vnet_private" {
  name                = "vnet-private"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet_app" {
  name                 = "subnet-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_private.name
  address_prefixes     = ["10.1.1.0/24"]
}


