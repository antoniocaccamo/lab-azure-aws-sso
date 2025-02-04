#data "archive_file" "func-keyvault-secret-rotation-zip" {
#  output_path = "../dist/fnc-keyvault-secret-rotation.zip"
#  type        = "zip"
#
#  source_dir = "../java/keyvault-secret-rotation/target/azure-functions"
#}


resource "azurerm_linux_function_app" "fnc-lab-aws-sso" {
  name                = "fnc-lab-aws-sso"
  resource_group_name = azurerm_resource_group.rg-lab-aws-sso.name
  location            = azurerm_resource_group.rg-lab-aws-sso.location
  service_plan_id     = azurerm_service_plan.splan-lab-aws-sso.id


  storage_account_name       = azurerm_storage_account.st-lab-aws-sso.name
  storage_account_access_key = azurerm_storage_account.st-lab-aws-sso.primary_access_key

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi-lab-aws-sso.id]
  }

  app_settings = {
    "ENABLE_ORYX_BUILD"              = true
    "BUILD_FLAGS"                     = "UseExpressBuild"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = true
#   "AzureWebJobsFeatureFlags"       = "EnableWorkerIndexing"
    "FUNCTIONS_WORKER_RUNTIME"       = "python"
    "AZURE_CLIENT_ID"                         = azurerm_user_assigned_identity.mi-lab-aws-sso.client_id
    "AUDIENCE"                                = local.audience
    "AWS_ROLE_ARN"                            = local.aws_role_name
    "AWS_S3_BUCKET"                           = local.aws_s3_bucket
    "USER_MANAGED_IDENTITY_CLIENT_ID"         = azurerm_user_assigned_identity.mi-lab-aws-sso.client_id
  }

  site_config {
    application_insights_key = azurerm_application_insights.ai-lab-aws-sso.instrumentation_key
    application_stack {
      python_version = "3.11"
    }
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
    ftps_state = "FtpsOnly"
    
  }
  tags                      = local.common_tags

  https_only                  = true
  functions_extension_version = "~4"

}



# resource "azurerm_linux_function_app" "flex-fnc-lab-aws-sso" {

#   name                = "fnc-flex-lab-aws-sso"
#   resource_group_name = azurerm_resource_group.rg-lab-aws-sso.name
#   location            = azurerm_resource_group.rg-lab-aws-sso.location
#   service_plan_id     = azurerm_service_plan.splan-lab-aws-sso.id


#   storage_account_name       = azurerm_storage_account.st-flex-lab-aws-sso.name
#   storage_account_access_key = azurerm_storage_account.st-flex-lab-aws-sso.primary_access_key

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.mi-lab-aws-sso.id]
#   }

#   app_settings = {
# #   "ENABLE_ORYX_BUILD"              = "true"
# #   "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
#     "FUNCTIONS_WORKER_RUNTIME"       = "python"
# #   "AzureWebJobsFeatureFlags"       = "EnableWorkerIndexing"
#     "AZURE_CLIENT_ID"                         = azurerm_user_assigned_identity.mi-lab-aws-sso.client_id
#     "AUDIENCE"                                = local.audience
#     "AWS_ROLE_ARN"                            = local.aws_role_name
#     "AWS_S3_BUCKET"                           = local.aws_s3_bucket
#     "USER_MANAGED_IDENTITY_CLIENT_ID"         = azurerm_user_assigned_identity.mi-lab-aws-sso.client_id
#   }

#   site_config {
#     application_insights_key = azurerm_application_insights.ai-lab-aws-sso.instrumentation_key
#     application_stack {
#       python_version = "3.11"
#     }
#     cors {
#       allowed_origins = ["https://portal.azure.com"]
#     }
#     ftps_state = "FtpsOnly"
#   }
#   tags                      = local.common_tags

#   https_only                  = true
#   functions_extension_version = "~4"

# }





# resource "azurerm_linux_function_app" "function_app" {
#   name                        = "${var.project}-function-app"
#   resource_group_name         = azurerm_resource_group.resource_group.name
#   location                    = var.location
#   service_plan_id             = azurerm_service_plan.app_service_plan.id
#   storage_account_name        = azurerm_storage_account.storage_account.name
#   storage_account_access_key  = azurerm_storage_account.storage_account.primary_access_key
#   https_only                  = true
#   functions_extension_version = "~4"
#   app_settings = {
#     "ENABLE_ORYX_BUILD"              = "true"
#     "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
#     "FUNCTIONS_WORKER_RUNTIME"       = "python"
#     "AzureWebJobsFeatureFlags"       = "EnableWorkerIndexing"
#     "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.application_insight.instrumentation_key
#   }

#   site_config {
#     application_stack {
#       python_version = "3.11"
#     }
#   }

#   zip_deploy_file = data.archive_file.function.output_path
# }