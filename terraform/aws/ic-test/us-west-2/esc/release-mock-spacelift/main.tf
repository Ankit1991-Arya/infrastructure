terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      ApplicationOwner    = "r&descworkstream@niceincontact.com"
      InfrastructureOwner = "r&descworkstream@niceincontact.com"
      Product             = "ACD-EntityManagement"
      Service             = "Release Mock Spacelift"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "release-mock-spacelift" {
  source  = "spacelift.io/incontact/orch-entity-release-mock-spacelift/default"
  version = "0.1.160"

  app-version = "v0.126.0"

  s3-bucket       = "to-entitymanagement"
  aws-region      = "us-west-2"
  aws-region-id   = "to"
  role-name       = "ServiceAccess-entitymanagement-release-mock-spacelift"
  resource-prefix = "entitymanagement"
  test-var        = "TestValue 8"
}

