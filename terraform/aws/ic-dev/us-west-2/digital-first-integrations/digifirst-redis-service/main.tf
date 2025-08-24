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
      Owner       = "Digital Engagement"
      Product     = "Digital Engagement"
      Repository  = "https://github.com/inContact/infrastructure-live"
    }
  }
}

module "digifirst-redis-service-stack" {
  source      = "spacelift.io/incontact/digifirst-redis-service-stack/default"
  version     = ">= 0.1.1"
  redis_queue = "digifirst-redis-queue"
  redis_dlq   = "digifirst-redis-queue-dlq"
}