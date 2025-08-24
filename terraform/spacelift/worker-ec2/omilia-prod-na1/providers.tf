terraform {
  required_version = "1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.58.0"
    }
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "1.14.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = local.standard_tags
  }
}

provider "spacelift" {
  api_key_endpoint = local.spacelift_api_key_endpoint
}