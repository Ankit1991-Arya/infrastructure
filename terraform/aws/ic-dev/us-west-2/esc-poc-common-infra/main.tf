terraform {
  required_version = ">= 1.3.7"
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
      ApplicationOwner    = "ESC-Vayu/cxone_esc_vayu@nice.com"
      InfrastructureOwner = "ESC-Vayu/cxone_esc_vayu@nice.com"
      Product             = "ACD"
      Service             = "Point Of Contact"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "esc-poc-management-common-infra" {
  source  = "spacelift.io/incontact/esc-poc-management-common-infra/default"
  version = "0.1.10" // Version of the Terraform module to deploy
  // This configuration is intended to grant access to AuroraDB from the developers' workstations
  developers_cidr = "10.21.0.0/19" // Add this only in ic-dev
  database_name   = "pocmanagementdb"
  min_acu         = 1
  max_acu         = 2
  environment     = "ic-dev"
}

