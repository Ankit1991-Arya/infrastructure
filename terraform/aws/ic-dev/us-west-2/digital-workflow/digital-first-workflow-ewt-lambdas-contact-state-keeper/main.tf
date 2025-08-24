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

  contact_state_keeper_image_tag = "98ab519be5ed0a7e99645c65c5bf3cc707067f86"
  duration_updater_image_tag     = "9cda7f80d647c3a20b3ceaca1c927e6f78e358f0"

  redis_url = "ewt-redis-cache-0001-001.ewt-redis-cache.gjo9pu.usw2.cache.amazonaws.com:6379 ewt-redis-cache-0001-002.ewt-redis-cache.gjo9pu.usw2.cache.amazonaws.com:6379"
}
