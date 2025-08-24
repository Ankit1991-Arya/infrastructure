terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Owner   = "MediaServices"
      Product = "POCRedirector"
      Repo    = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "pocredirector-dynamodb" {
  source  = "spacelift.io/incontact/pocredirector-dynamodb/default"
  version = "0.1.7"

  instance_name = "pocredirector"
}

module "pocredirector-elasticache" {
  source  = "spacelift.io/incontact/pocredirector-elasticache/default"
  version = "0.1.27"

  cluster_name = "pocredirector"
}
