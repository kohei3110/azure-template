terraform {
  required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>2.0"
      }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_virtual_machine" "this" {
  name = var.virtual_machine_name
  resource_group_name = var.resource_group_name
  location = var.location
  network_interface_ids = [var.network_interface_ids]
  os_profile_linux_config {
    
  }
}