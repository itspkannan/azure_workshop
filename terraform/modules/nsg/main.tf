resource "azurerm_network_security_group" "private_nsg" {
  name                = "nsg-private"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "allow_lb_http" {
  name                        = "Allow-HTTP-From-LB"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.private_nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}
