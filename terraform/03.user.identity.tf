resource "azurerm_user_assigned_identity" "mi-lab-aws-sso" {
    name = "mi-${local.base_name}"
    location            = azurerm_resource_group.rg-lab-aws-sso.location
    resource_group_name = azurerm_resource_group.rg-lab-aws-sso.name
     tags = merge(
        local.common_tags
    )
}