terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      Owner   = "Digital-Workflow"
      Product = "Digital Hopper"
      Repo    = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "digital_hopper_rds" {
  source  = "spacelift.io/incontact/digital-hopper-rds/default"
  version = "0.2.27"

  env             = "al"
  vpc_name_common = "CoreNetwork"
  engine_version  = "8.0.mysql_aurora.3.07.1"
}
