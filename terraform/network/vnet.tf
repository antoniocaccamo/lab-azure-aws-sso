# virtual network

resource "azurerm_virtual_network" "vnet" {
  name = "vnet-${var.base_name}"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = [ "10.0.0.0/16" ]

  tags = var.common_tags
}

resource "azurerm_subnet" "subnet-appgw" {
  name = "subnet-appgw"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ "10.0.0.0/24" ]
  
}

resource "azurerm_subnet" "subnet-apim" {
  name = "subnet-apim"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ "10.0.1.0/24" ]
  
}

resource "azurerm_subnet" "subnet-prv-links" {
  name = "subnet-prv-links"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ "10.0.2.0/24" ]
  
}

# resource "azurerm_subnet" "subnet-apim-wl" {
#   name = "subnet-apim-wl"
#   resource_group_name = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes = [ "10.0.3.0/24" ]

# }


resource "azurerm_subnet" "subnet-jumphost" {
  name = "subnet-jumphost"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ "10.0.4.0/24" ]

}