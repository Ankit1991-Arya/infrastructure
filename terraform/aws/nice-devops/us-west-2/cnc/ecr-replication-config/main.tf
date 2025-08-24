terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.2"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      ApplicationOwner    = "CNC"
      InfrastructureOwner = "CNC"
      Product             = "ECR"
      Service             = "ECR Replication Rules"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}


variable "replication_rules" {
  description = "List of replication rules with repository prefix and targets"
  type = list(object({
    filter_prefix       = string
    replication_targets = map(list(string))
  }))
  default = [
    {
      filter_prefix = "nice-base-container-images"
      replication_targets = {
        "us-west-2" = ["300813158921", "625808405075"]
      }
    }
  ]
}


resource "aws_ecr_replication_configuration" "this" {
  replication_configuration {
    dynamic "rule" {
      for_each = var.replication_rules
      content {
        repository_filter {
          filter      = rule.value.filter_prefix
          filter_type = "PREFIX_MATCH"
        }

        dynamic "destination" {
          for_each = flatten([
            for region, accounts in rule.value.replication_targets : [
              for account_id in accounts : {
                region      = region
                registry_id = account_id
              }
            ]
          ])
          content {
            region      = destination.value.region
            registry_id = destination.value.registry_id
          }
        }
      }
    }
  }
}
