


resource "azurerm_storage_account" "st-lab-aws-sso" {
  name                     = "stclabawssso${random_string.unique.result}"
  location            = azurerm_resource_group.rg-lab-aws-sso.location
  resource_group_name = azurerm_resource_group.rg-lab-aws-sso.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled   = true
  default_to_oauth_authentication = true
  shared_access_key_enabled       = true
  allow_nested_items_to_be_public = false


  tags = merge(
     local.common_tags
  )
}

resource "azurerm_storage_account" "st-flex-lab-aws-sso" {
  name                     = "stcflexlabawssso${random_string.unique.result}"
  location            = azurerm_resource_group.rg-lab-aws-sso.location
  resource_group_name = azurerm_resource_group.rg-lab-aws-sso.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled   = true
  default_to_oauth_authentication = true
  shared_access_key_enabled       = true
  allow_nested_items_to_be_public = false


  tags = merge(
     local.common_tags
  )
}




#------------------------------------------------------------------------------

resource "azurerm_role_assignment" "st-lab-aws-sso-role-assignment-enterprise-app-rotate-00" {
  principal_id         = azurerm_user_assigned_identity.mi-lab-aws-sso.principal_id
  scope                = azurerm_storage_account.st-lab-aws-sso.id
  role_definition_name = "Owner"
}

resource "azurerm_role_assignment" "st-lab-aws-sso-role-assignment-enterprise-app-rotate-01" {
  principal_id         = azurerm_user_assigned_identity.mi-lab-aws-sso.principal_id
  scope                = azurerm_storage_account.st-lab-aws-sso.id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_role_assignment" "st-flex-lab-aws-sso-role-assignment-enterprise-app-rotate-00" {
  principal_id         = azurerm_user_assigned_identity.mi-lab-aws-sso.principal_id
  scope                = azurerm_storage_account.st-flex-lab-aws-sso.id
  role_definition_name = "Owner"
}

resource "azurerm_role_assignment" "st-flex-lab-aws-sso-assignment-enterprise-app-rotate-01" {
  principal_id         = azurerm_user_assigned_identity.mi-lab-aws-sso.principal_id
  scope                = azurerm_storage_account.st-flex-lab-aws-sso.id
  role_definition_name = "Storage Blob Data Contributor"
}