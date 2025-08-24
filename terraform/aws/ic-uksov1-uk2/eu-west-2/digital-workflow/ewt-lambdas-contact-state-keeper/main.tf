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

module "digital-first-workflow-ewt-lambdas-contact-state-keeper" {
  source  = "spacelift.io/incontact/digital-first-workflow-ewt-lambdas-contact-state-keeper/default"
  version = "1.0.11"

  region                         = "eu-west-2"
  aws_region_id                  = "uklo"
  kinesis_region_id              = "lo"
  redis_url                      = "ewt-redis-cache-0001-001.ewt-redis-cache.qglnk0.euw2.cache.amazonaws.com:6379 ewt-redis-cache-0001-002.ewt-redis-cache.qglnk0.euw2.cache.amazonaws.com:6379"
  contact_state_keeper_image_tag = "02b833e8c027d286846d4e2d81ca4ca840f598a5"
  duration_updater_image_tag     = "02b833e8c027d286846d4e2d81ca4ca840f598a5"
}