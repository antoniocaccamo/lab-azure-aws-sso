# NSGs

# NSG for appgw subnet
resource "azurerm_network_security_group" "nsg-subnet-appgw" {
  name = "nsg-subnet-appgw"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = var.common_tags
}

resource "azurerm_network_security_rule" "sec-rule-subnet-appgw-001" {
  name = "http"
  priority = 200
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "*"
  destination_port_ranges = ["80", "443"]
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-subnet-appgw.name
  
}

resource "azurerm_subnet_network_security_group_association" "sec-rule-subnet-appgw-001-association" {
  subnet_id                 = azurerm_subnet.subnet-appgw.id
  network_security_group_id = azurerm_network_security_group.nsg-subnet-appgw.id
}

# NSG for apim subnet
# -------------------
resource "azurerm_network_security_group" "nsg-subnet-apim" {
  name = "nsg-subnet-apim"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "sec-rule-subnet-apim-001-association" {
  subnet_id                 = azurerm_subnet.subnet-apim.id
  network_security_group_id = azurerm_network_security_group.nsg-subnet-apim.id
}

resource "azurerm_network_security_rule" "sec-rule-subnet-apim-001" {
  name = "http"
  priority = 200
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "*"
  destination_port_ranges = ["80", "443"]
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-subnet-apim.name
}

resource "azurerm_network_security_rule" "sec-rule-subnet-apim-002" {
  name = "allow-inbound-tcp-6390"
  priority = 220
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "AzureLoadBalancer"
  destination_port_ranges = ["6390"]
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-subnet-apim.name  
}

resource "azurerm_network_security_rule" "sec-rule-subnet-apim-003" {
  name = "allow-inbound-tcp-3443"
  priority = 240
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "ApimManagement"
  destination_port_ranges = ["3443"]
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-subnet-apim.name  
}



# NSG for appgw-wl subnet
resource "azurerm_network_security_group" "nsg-subnet-appgw-wl" {
  name = "nsg-subnet-appgw-wl"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = var.common_tags
}

resource "azurerm_network_security_rule" "sec-rule-subnet-appgw-wl-001" {
  name = "http"
  priority = 200
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "*"
  destination_port_ranges = ["80", "443"]
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-subnet-appgw-wl.name
  
}


resource "azurerm_subnet_network_security_group_association" "sec-rule-subnet-appgw-wl-001-association" {
  subnet_id                 = azurerm_subnet.subnet-appgw-wl.id
  network_security_group_id = azurerm_network_security_group.nsg-subnet-appgw-wl.id
}

# NSG for apim-wl subnet
resource "azurerm_network_security_group" "nsg-subnet-apim-wl" {
  name = "nsg-subnet-apim-wl"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = var.common_tags
}

resource "azurerm_network_security_rule" "sec-rule-subnet-apim-wl-001" {
  name = "http"
  priority = 200
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "*"
  destination_port_ranges = ["80", "443"]
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-subnet-apim-wl.name
  
}

resource "azurerm_subnet_network_security_group_association" "sec-rule-subnet-apim-wl-001-association" {
  subnet_id                 = azurerm_subnet.subnet-apim-wl.id
  network_security_group_id = azurerm_network_security_group.nsg-subnet-apim-wl.id
}


# NSG for jumphost subnet
resource "azurerm_network_security_group" "nsg-subnet-jumphost" {
  name = "nsg-subnet-jumphost"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = var.common_tags
}

resource "azurerm_network_security_rule" "sec-rule-subnet-jumphost-001" {
  name = "http"
  priority = 200
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "*"
  destination_port_ranges = ["80", "443"]
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-subnet-jumphost.name

}

resource "azurerm_network_security_rule" "sec-rule-subnet-jumphost-002" {
  name = "ssh"
  priority = 300
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_address_prefix = var.my_ip
  source_port_range = "*"
  destination_address_prefix = "*"
  destination_port_ranges = ["22"]
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg-subnet-jumphost.name

}

resource "azurerm_subnet_network_security_group_association" "sec-rule-subnet-jumphost-001-association" {
  subnet_id                 = azurerm_subnet.subnet-jumphost.id
  network_security_group_id = azurerm_network_security_group.nsg-subnet-jumphost.id
}


