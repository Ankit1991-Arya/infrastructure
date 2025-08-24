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
  region = "ap-southeast-2"
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

  region                         = "ap-southeast-2"
  aws_region_id                  = "ausy"
  kinesis_region_id              = "sy"
  redis_url                      = "ewt-redis-cache-0001-001.ewt-redis-cache.5lmpkg.apse2.cache.amazonaws.com:6379 ewt-redis-cache-0001-002.ewt-redis-cache.5lmpkg.apse2.cache.amazonaws.com:6379"
  contact_state_keeper_image_tag = "d6040192d69317cb9ffc36c3ef8aa12e9b43d36b"
  duration_updater_image_tag     = "d6040192d69317cb9ffc36c3ef8aa12e9b43d36b"
}
