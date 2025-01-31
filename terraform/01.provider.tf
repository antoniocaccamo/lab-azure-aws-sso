terraform {
  required_providers {
    azurerm = {
      version = "~> 3.66.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "st0terraform0state0000"
    container_name       = "terraform-lab-aws-sso"
    key                  = "terraform.tfstate"
  }

}


resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

resource "random_uuid" "uuid" {}