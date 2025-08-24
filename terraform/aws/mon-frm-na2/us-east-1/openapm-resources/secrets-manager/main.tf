terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 5.0.0"
    }
  }
  required_version = ">= 1.3.7"
}

provider "aws" {
  region = "us-east-1"
}

locals {
  secrets_data = yamldecode(file("./inputs.yaml"))
}

module "secrets_manager" {
  source       = "spacelift.io/incontact/openapm-secrets-manager-module/default"
  version      = "0.0.3"
  secrets_data = local.secrets_data.secrets_data
}