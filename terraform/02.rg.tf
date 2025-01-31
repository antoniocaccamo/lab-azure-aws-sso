resource "azurerm_resource_group" "rg-lab-aws-sso" {
    location = local.location
    name = "rg-ne-${local.base_name}"
    tags = merge(
        local.common_tags
    )
}


