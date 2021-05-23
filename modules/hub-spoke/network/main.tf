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

locals {
  env = var.env
  tags = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.address_space]
  dns_servers         = var.dns_servers
  tags                = local.tags
}

resource "azurerm_virtual_network_peering" "this" {
  name                = var.vnet_peering_name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_peering_vnet_name
  remote_virtual_network_id = var.remote_virtual_network_id
}

# resource "azurerm_subnet" "subnet" {
#   count                                          = length(var.subnet_names)
#   name                                           = var.subnet_names[count.index]
#   resource_group_name                            = azurerm_resource_group.this.name
#   address_prefixes                               = [var.subnet_prefixes[count.index]]
#   virtual_network_name                           = azurerm_virtual_network.vnet.name
#   enforce_private_link_endpoint_network_policies = lookup(var.subnet_enforce_private_link_endpoint_network_policies, var.subnet_names[count.index], false)
# }