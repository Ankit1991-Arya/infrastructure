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
  region = "us-west-2"
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
  version = ">= 0.1.0"

  aws_region_id                  = "so"
  redis_url                      = "ewt-redis-cache-0001-001.ewt-redis-cache.imswog.usw2.cache.amazonaws.com:6379 ewt-redis-cache-0001-002.ewt-redis-cache.imswog.usw2.cache.amazonaws.com:6379"
  contact_state_keeper_image_tag = "6696a7011ee50184c235a274949f0fef04e6ab66"
  duration_updater_image_tag     = "6696a7011ee50184c235a274949f0fef04e6ab66"
}
