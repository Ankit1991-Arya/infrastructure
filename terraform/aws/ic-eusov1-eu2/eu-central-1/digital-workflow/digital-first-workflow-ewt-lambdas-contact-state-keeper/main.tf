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
  region = "eu-central-1"
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
  version = "1.0.10"

  region                         = "eu-central-1"
  aws_region_id                  = "euft"
  kinesis_region_id              = "ft"
  redis_url                      = "ewt-redis-cache-0001-001.ewt-redis-cache.eq8jq4.euc1.cache.amazonaws.com:6379 ewt-redis-cache-0001-002.ewt-redis-cache.eq8jq4.euc1.cache.amazonaws.com:6379"
  contact_state_keeper_image_tag = "c0713a9b3b9d85d8b75ca13a72ca9a212a707a66"
  duration_updater_image_tag     = "c0713a9b3b9d85d8b75ca13a72ca9a212a707a66"
}