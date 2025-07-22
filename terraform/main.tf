terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus2"
}

resource "azurerm_resource_group" "main" {
  name     = "secure-arch-rg"
  location = var.location
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
}

module "nsg" {
  source              = "./modules/nsg"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  subnet_id           = module.networking.subnet_app_id
}

module "load_balancer" {
  source              = "./modules/load_balancer"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  subnet_id           = module.networking.subnet_lb_id
}

# Skpping roles for now
#module "roles" {
#  source            = "./modules/roles"
#  resource_group_id = azurerm_resource_group.main.id
#}


module "vm_nginx" {
  source              = "./modules/vm_nginx"
  vm_name             = "vm-nginx"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.networking.subnet_ids["private"]
  admin_username      = "azureuser"
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
}