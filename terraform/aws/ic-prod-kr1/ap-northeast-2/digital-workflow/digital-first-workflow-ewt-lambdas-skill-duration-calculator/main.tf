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
  region = "ap-northeast-2"
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
  version = "1.0.27"

  aws_region_id                       = "acsl"
  skill_duration_calculator_image_tag = "d6040192d69317cb9ffc36c3ef8aa12e9b43d36b"
  api_gateway_authorizer_image_tag    = "d6040192d69317cb9ffc36c3ef8aa12e9b43d36b"
  redis_url                           = "ewt-redis-cache-0001-001.ewt-redis-cache.avuink.apn2.cache.amazonaws.com:6379 ewt-redis-cache-0001-002.ewt-redis-cache.avuink.apn2.cache.amazonaws.com:6379"
  key_uri                             = "https://cxone.niceincontact.com/auth/jwks"
}
