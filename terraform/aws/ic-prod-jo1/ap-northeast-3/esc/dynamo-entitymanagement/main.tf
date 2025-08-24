terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

provider "aws" {
  region = "ap-northeast-3"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "ACD-EntityManagement"
      Service             = "dynamo-entitymanagement"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

#tfsec:ignore:aws-dynamodb-enable-recovery
module "dynamo-entitymanagement" {
  source  = "spacelift.io/incontact/orch-aws-terraform-dynamo-entitymanagement/default"
  version = "0.0.3"

  environment-prefix = "acos"
  region             = "ap-northeast-3"
}
