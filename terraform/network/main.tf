resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.base_name}"
  location = "northeurope"
  tags = var.common_tags
}



