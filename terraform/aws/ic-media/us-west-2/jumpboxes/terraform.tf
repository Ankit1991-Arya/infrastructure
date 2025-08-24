terraform {
  required_version = ">= 1.5.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Owner   = "MediaServices"
      Product = "MediaServicTools"
      Repo    = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}