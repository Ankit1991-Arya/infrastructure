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
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "entitymanagement"
      Service             = "Api Services"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "terraform-default-aurora-rds-alarms-development" {
  //change remove the source as dev once testing is done
  source  = "spacelift.io/incontact/aurora-rds-alarms-development/default"
  version = "0.0.1" // Version of the Terraform module to deploy
}

