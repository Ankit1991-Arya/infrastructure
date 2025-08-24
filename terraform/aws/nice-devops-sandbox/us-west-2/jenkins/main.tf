terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "jenkins_infra" {
  source = "github.com/inContact/infra-sonar.git//modules/mgmt/jenkins?ref=v1.1.2"
}