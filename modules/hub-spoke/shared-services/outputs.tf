output "resource_group_name" {
  description = "The name of the resource groups"
  value = azurerm_resource_group.this.name
}

output "resource_group_location" {
  description = "The name of the resource groups"
  value = azurerm_resource_group.this.location
}
