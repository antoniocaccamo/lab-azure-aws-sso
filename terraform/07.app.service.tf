
resource "azurerm_service_plan" "splan-lab-aws-sso" {
  name                = "splan-lab-aws-sso"
  resource_group_name = azurerm_resource_group.rg-lab-aws-sso.name
  location            = azurerm_resource_group.rg-lab-aws-sso.location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = local.common_tags
}

resource "azurerm_application_insights" "ai-lab-aws-sso" {
  name                = "ai-splan-lab-aws-sso"
  location            = azurerm_resource_group.rg-lab-aws-sso.location
  resource_group_name = azurerm_resource_group.rg-lab-aws-sso.name
  application_type    = "other"

  #  workspace_id = azurerm_log_analytics_workspace.law-secret-rotation.id

  tags = local.common_tags
}

