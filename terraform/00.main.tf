data "azurerm_client_config" "current" {}


provider "azurerm" {
  features {}
  skip_provider_registration = "true"
}


locals {
  base_name     = "lab-aws-sso"
  location      = "northeurope"
  tenant_id     = data.azurerm_client_config.current.tenant_id
  support_name  = "antonio caccamo"
  support_email = "caccamo.antonio.@gmail.com"
  common_tags = {
    env     = "development"
    project = "lab-aws-sso"
    source  = "terraform"
  }
  audience = "api://7b917162-75b1-48f3-94c2-7ff5d1f95fe8"
  aws_role_name="arn:aws:iam::195275645436:role/CentralLogForAzureRole"
  aws_s3_bucket="antoniocaccamo-central-log"
}


