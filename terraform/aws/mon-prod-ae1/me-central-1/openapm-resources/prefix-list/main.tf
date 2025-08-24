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
  region = "me-central-1"
}

locals {
  prefix_list_data = yamldecode(file("./inputs.yaml"))
}

module "prefix_list" {
  source           = "spacelift.io/incontact/openapm-prefix-list-module/default"
  version          = "0.0.1"
  prefix_list_data = local.prefix_list_data.prefix_list_data
}