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
  region = "us-west-2"
}

locals {
  security_group_data = yamldecode(file("./inputs.yaml"))
}

module "openapm-security-group-module" {
  source              = "spacelift.io/incontact/openapm-security-group-module/default"
  version             = "0.3.8"
  security_group_data = local.security_group_data.security_group_data
}