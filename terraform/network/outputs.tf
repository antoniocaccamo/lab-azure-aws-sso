output "resource-group-name-out" {
  value = azurerm_resource_group.rg-poc-agw-apim.name
}

output "subnet-appgw-wl-id-out" {
    value = azurerm_subnet.subnet-appgw-wl.id
}

output "subnet-apim-wl-id-out" {
  value = azurerm_subnet.subnet-apim-wl.id
}

output "subnet-jumphost-id-out" {
  value = azurerm_subnet.subnet-jumphost.id
}