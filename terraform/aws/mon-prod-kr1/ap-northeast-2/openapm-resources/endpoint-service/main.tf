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
  region = "ap-northeast-2"
}

locals {
  endpoint_service_data = yamldecode(file("./inputs.yaml"))
}

module "openapm-endpoint-service-modules" {
  source                = "spacelift.io/incontact/openapm-endpoint-service-modules/default"
  version               = "0.1.9"
  endpoint_service_data = local.endpoint_service_data.endpoint_service_data
}