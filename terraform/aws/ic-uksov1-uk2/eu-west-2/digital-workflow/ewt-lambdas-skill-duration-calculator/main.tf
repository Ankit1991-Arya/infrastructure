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
      Product = "Estimated Wait Time"
      Repo    = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "digital-first-workflow-ewt-lambdas-skill-duration-calculator" {
  source  = "spacelift.io/incontact/digital-first-workflow-ewt-lambdas-skill-duration-calculator/default"
  version = "1.0.28"

  aws_region_id                       = "uklo"
  skill_duration_calculator_image_tag = "02b833e8c027d286846d4e2d81ca4ca840f598a5"
  api_gateway_authorizer_image_tag    = "02b833e8c027d286846d4e2d81ca4ca840f598a5"
  redis_url                           = "ewt-redis-cache-0001-001.ewt-redis-cache.qglnk0.euw2.cache.amazonaws.com:6379 ewt-redis-cache-0001-002.ewt-redis-cache.qglnk0.euw2.cache.amazonaws.com:6379"
  key_uri                             = "https://nicecxone-sov1.uk/auth/jwks"
}