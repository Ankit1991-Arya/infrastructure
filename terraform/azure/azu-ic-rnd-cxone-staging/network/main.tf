
terraform {
  required_version = "~>1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.29.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.22"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>0.6"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "aws" {
  alias  = "ic_staging"
  region = "us-west-2"
}

provider "aws" {
  region = "us-west-2"
}
