variable "env" {
  description = "Environment name"
  type = string
  default = ""
}

variable "resource_group_name" {
  description = "Resource group name"
  type = string
  default = ""
}

variable "location" {
  description = "Resource location"
  type = string
  default = ""
}

variable "vnet_name" {
  description = "Name of the vnet to create."
  type        = string
  default     = "acctvnet"
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = []
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = [""]
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default     = {}
}

variable "subnet_enforce_private_link_endpoint_network_policies" {
  description = "A map with key (string) `subnet name`, value (bool) `true` or `false` to indicate enable or disable network policies for the private link endpoint on the subnet. Default value is false."
  type        = map(bool)
  default     = {}
}

variable "vnet_peering_name" {
  description = "The name of vnet_peering."
  type = string
  default = ""
}

variable "vnet_peering_vnet_name" {
  description = "The name of the virtual network."
  type = string
  default = ""
}

variable "remote_virtual_network_id" {
  description = "The full Azure resource ID of the remote virtual network."
  type = string
  default = ""
}
