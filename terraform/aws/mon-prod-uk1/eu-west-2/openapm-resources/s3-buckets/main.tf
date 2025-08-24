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
  region = "eu-west-2"
}

locals {
  s3_bucket_data = yamldecode(file("./inputs.yaml"))
}

module "openapm-s3-bucket-module" {
  source         = "spacelift.io/incontact/openapm-s3-bucket-module/default"
  version        = "1.4.9"
  s3_bucket_data = local.s3_bucket_data.s3_bucket_data
}