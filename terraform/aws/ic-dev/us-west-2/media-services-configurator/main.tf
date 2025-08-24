terraform {
  required_version = ">= 1.5.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0.0,< 6.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Owner               = "MediaServices"
      Product             = "ACD"
      Service             = "Media Server"
      ApplicationOwner    = "MediaServices"
      InfrastructureOwner = "MediaServices"
    }
  }
}

module "media-service-configurator-s3-bucket" {
  source  = "spacelift.io/incontact/media-service-configurator-s3-bucket/default"
  version = "0.0.7"

  # Required inputs
  bucket_name = "media-services-configurations"
}