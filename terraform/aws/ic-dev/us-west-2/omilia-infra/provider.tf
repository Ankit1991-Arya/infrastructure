terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      ApplicationOwner    = "CNC"
      InfrastructureOwner = "CNC"
      Product             = "Omilia"
      Service             = "Omilia"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}