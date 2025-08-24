terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 5.64.0"
    }
  }
  required_version = ">= 1.0"
}
provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Owner               = "Systems Engineering"
      Product             = "System"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      Service             = "Logscale"
      InfrastructureOwner = "Systems Engineering"
      ApplicationOwner    = "Systems Engineering"
    }
  }
}

locals {
  logscale_sg_data = yamldecode(file("./inputs.yaml"))
}
