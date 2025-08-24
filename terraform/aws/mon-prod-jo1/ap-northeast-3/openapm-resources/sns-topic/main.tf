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
  region = "ap-northeast-3"
}

locals {
  sns_data = yamldecode(file("./inputs.yaml"))
}

module "sns_topics" {
  source   = "spacelift.io/incontact/openapm-sns-topics-module/default"
  version  = "0.0.4"
  sns_data = local.sns_data.sns_data
}