terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.96"
    }
  }
}

locals {
  tags = {
    InfrastructureOwner = "Cloud Native Core/devops-cloud-native-core@nice.com"
    ApplicationOwner    = "Cloud Native Core/devops-cloud-native-core@nice.com"
    Product             = "Infrastructure"
    Service             = "Cellular Shared EKS"
    Repository          = "https://github.com/inContact/infrastructure-live"
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = local.tags
  }
}

module "vpc" {
  source = "github.com/inContact/acddevops-terraform-modules-eks.git//modules/single-tenant-vpc?ref=single-tenant-eks"

  tags = local.tags
}
