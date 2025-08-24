terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 5.0.0"
    }
  }
  required_version = ">= 1.0"
}
provider "aws" {
  region = "us-west-2"
}

locals {
  private_link_data = yamldecode(file("./inputs.yaml"))
}

module "privatelink_endpoint" {
  source  = "spacelift.io/incontact/aws_privatelink_vpc_endpoint/default"
  version = "0.1.2"
  # source            = "github.com/inContact/aws-terraform-modules-network.git//modules/aws_privatelink_vpc_endpoint?ref=CNC-3977-sg-dynamic-ingress"
  private_link_data = local.private_link_data.private_link_data
}