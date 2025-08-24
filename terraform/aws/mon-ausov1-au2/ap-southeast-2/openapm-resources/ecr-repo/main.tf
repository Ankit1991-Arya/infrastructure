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
  region = "ap-southeast-2"
}

locals {
  ecr_repo_data = yamldecode(file("./inputs.yaml"))
}

module "ecr_repo" {
  source        = "spacelift.io/incontact/openapm-terraform-modules/default"
  version       = "0.0.2"
  ecr_repo_data = local.ecr_repo_data.ecr_repo_data
}