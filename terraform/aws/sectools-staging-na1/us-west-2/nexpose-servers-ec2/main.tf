terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 5.90.1"
    }
  }
  required_version = ">= 1.0"
}
provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Owner               = "Systems Engineering"
      Product             = "System"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      Service             = "EC2"
      InfrastructureOwner = "Systems Engineering"
      ApplicationOwner    = "Systems Engineering"
    }
  }
}

locals {
  resource_gateway_data = yamldecode(file("./resource_gateway.yaml"))
}


module "vpc_resource_gateway" {
  source                = "github.com/inContact/aws-terraform-modules-network.git//modules/aws_resource_gateway?ref=resource-gateway"
  resource_gateway_data = local.resource_gateway_data.resource_gateway_data
}