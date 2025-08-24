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
  region = "eu-central-1"
}

locals {
  s3control_storage_lens_data = yamldecode(file("./inputs.yaml"))
}

module "openapm-s3-bucket-module" {
  source                      = "spacelift.io/incontact/openapm-s3_control-storage-lens-configuration-module/default"
  version                     = "0.1.6"
  s3control_storage_lens_data = local.s3control_storage_lens_data.s3control_storage_lens_data
}
