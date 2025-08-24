terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3, < 4.0.0"
    }
  }
}

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      ApplicationOwner    = "Systems Teams"
      InfrastructureOwner = "Systems Teams"
      Product             = "Infrastructure"
      Service             = "SES-SMTP-Credentials"
      Repository          = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}