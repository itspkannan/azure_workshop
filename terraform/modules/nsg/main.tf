resource "azurerm_network_security_group" "private_nsg" {
  name                = "nsg-private"
  location            = var.location
  resource_group_name = var.resource_group_name
}

#  Allow HTTP from Azure Load Balancer
resource "azurerm_network_security_rule" "allow_http_from_lb" {
  name                        = "Allow-HTTP-From-Azure-LB"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "AzureLoadBalancer" # Azure service tag
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.private_nsg.name
  resource_group_name         = var.resource_group_name
}

#  Allow HTTP from your own IP
resource "azurerm_network_security_rule" "allow_http_from_admin_ip" {
  name                        = "Allow-HTTP-From-Admin-IP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "24.6.142.153/32" # Replace with your IP
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.private_nsg.name
  resource_group_name         = var.resource_group_name
}

# Deny all other inbound traffic
resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "Deny-All-Inbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.private_nsg.name
  resource_group_name         = var.resource_group_name
}

# Associate NSG with subnet
resource "azurerm_subnet_network_security_group_association" "assoc" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}
