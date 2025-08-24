terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      InfrastructureOwner : "Cloud Native Core/devops-cloud-native-core@NiceinContact.com"
      Product : "Infrastructure"
      Service : "Shared MSK"
      Repository = "https://github.com/inContact/infrastructure-live"
    }
  }
}

# VPC Module
# tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
module "vpc" {
  source = "github.com/inContact/aws-terraform-modules-network.git//modules/aws_vpc?ref=CNC-4942-aws-vpc-module-test"

  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  vpc_name             = "Public-MSK-VPC"
  enable_vpc_flow_log  = true
}

# Internet Gateway Module
module "internet_gateway" {
  source = "github.com/inContact/aws-terraform-modules-network.git//modules/aws_internet_gateway?ref=CNC-4942-aws-vpc-module-test"

  create_igw = true
  vpc_id     = module.vpc.id
  igw_name   = "Public-MSK-VPC-internet-gateway"
}
