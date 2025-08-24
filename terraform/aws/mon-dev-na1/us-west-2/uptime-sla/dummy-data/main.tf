terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0.0"
    }
  }
}

#AWS provider configuration
provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Product             = "Platform"
      Service             = "UptimeEvaluationService"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      InfrastructureOwner = "S and C Platform / Security and Compliance_Earth@nice.com"
      ApplicationOwner    = "S andC Platform / Security and Compliance_Earth@nice.com"
    }
  }
}

resource "aws_dynamodb_table_item" "dependecy_store_item" {
  table_name = "service_dependency_store"
  hash_key   = "service_id"
  item       = <<ITEM
  {
    "service_id": {"S": "66b8f84d-df4e-4d49-b662-bcde71a8764f"},
    "dependent_service_id": {"S": "56b8f8d-df4e-4d49-b662-bcde71a8764f"},
    "record_creation_date": {"S": "1739520515"}
  }
  ITEM
}

resource "aws_dynamodb_table_item" "service_registry_item" {
  table_name = "service_registry_store"
  hash_key   = "service_id"
  item       = <<ITEM
  {
    "service_id": {"S": "36b8f84d-df4e-4d49-b662-bcde71a8764f"},
    "service_name": {"S": "ServiceA"},
    "registration_date": {"S": "1739520515"},
    "service_description": {"S": "ServiceA Description"},
    "enable_external_status": {"S": "FALSE"},
    "parent_service_id": {"S": "56b8f8d-df4e-4d49-b662-bcde71a8764f"},
    "is_active": {"S": "TRUE"},
    "service_owner_team": {"S": "SQT_4567"},
    "service_owner_team_POC": {"S": "SQT_236"},
    "committed_sla": {"S": "99.99"},
    "monitoring_frequency": {"N": "12"},
    "region": {"S": "Oregon"},
    "isGlobalService": {"S": "Global"}
  }
  ITEM
}