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

############################################
# Resource Group 
############################################
module "resource_group" {
  source = "../../../modules/hub-spoke/shared-services"

  resource_group_name = "Hub-Spoke"
}

data "azurerm_resource_group" "this" {
  name = module.resource_group.resource_group_name
}

############################################
# Network 
############################################
module "hub" {
  source = "../../../modules/hub-spoke/network"

  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  env                 = "free-tier"
  vnet_name           = "hub-vnet"
  address_space       = "10.0.0.0/16"
  # vnet_peering_vnet_name = module.hub.vnet_name
  # remote_virtual_network_id = module.hub.vnet_id
  tags = {
    env = "dev"
  }
}

module "spoke_1" {
  source = "../../../modules/hub-spoke/network"

  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  env                 = "free-tier"
  vnet_name           = "spoke1-vnet"
  address_space       = "172.16.0.0/16"
  vnet_peering_name   = "hub-spoke_1"
  vnet_peering_vnet_name = module.hub.vnet_name
  remote_virtual_network_id = module.spoke_1.vnet_id
  tags = {
    env = "dev"
  }
}

module "spoke_2" {
  source = "../../../modules/hub-spoke/network"

  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  env                 = "free-tier"
  vnet_name           = "spoke2-vnet"
  address_space       = "192.168.0.0/16"
  vnet_peering_name   = "hub-spoke_2"
  vnet_peering_vnet_name = module.hub.vnet_name
  remote_virtual_network_id = module.spoke_2.vnet_id
  tags = {
    env = "dev"
  }
}