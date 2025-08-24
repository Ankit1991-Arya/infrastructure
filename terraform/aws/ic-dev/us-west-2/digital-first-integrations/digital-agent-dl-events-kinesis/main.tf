terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Environment = "dev"
      Repository  = "https://github.com/inContact/infrastructure-live"
    }
  }
}

module "kinesis-stream" {
  source      = "spacelift.io/incontact/kinesis-digital-agent-dl-events-stream/default"
  version     = ">= 0.1.5"
  name        = "dev-digital-agent-dl-events"
  shard_count = 2
}