terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Environment = "dev"
      Repository  = "https://github.com/inContact/infrastructure-live"
    }
  }
}

module "kms-key" {
  source        = "spacelift.io/incontact/dfo-terraform-modules-dx-integration-streams-key/default"
  version       = ">= 0.1.0"
  kms_key_name  = "dx-integration-streams-kms-key"
  kms_key_alias = "dx-integration-streams-kms-key"
}