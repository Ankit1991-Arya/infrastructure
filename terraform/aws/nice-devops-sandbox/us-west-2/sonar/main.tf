terraform {
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
  region = "us-west-2"
}

module "sonar_infra" {
  source = "github.com/inContact/infra-sonar.git//modules/sonar-rds?ref=v1.0.2"
}