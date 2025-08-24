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
  region = "us-west-2"
}

locals {
  route53_record_data = yamldecode(file("./inputs.yaml"))
}

module "route53_record" {
  source              = "spacelift.io/incontact/openapm-route53-record-module/default"
  version             = "0.0.3"
  route53_record_data = local.route53_record_data.route53_record_data
}