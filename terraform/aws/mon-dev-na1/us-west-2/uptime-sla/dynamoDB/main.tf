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

locals {
  config_data = yamldecode(file("./inputs.yaml"))
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

resource "aws_kms_key" "dynamodb_key" {
  description         = "KMS key for DynamoDB encryption"
  enable_key_rotation = true
}

# DynamoDB schema for service registry store
resource "aws_dynamodb_table" "service_registry_store" {
  name           = "service_registry_store"
  billing_mode   = local.config_data.data.role.billing_mode
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "service_id"
  range_key      = "service_name"

  attribute {
    name = "service_id"
    type = "S"
  }

  attribute {
    name = "service_name"
    type = "S"
  }

  attribute {
    name = "registration_date"
    type = "S"
  }

  attribute {
    name = "service_description"
    type = "S"
  }

  attribute {
    name = "enable_external_status"
    type = "S"
  }

  attribute {
    name = "parent_service_id"
    type = "S"
  }

  attribute {
    name = "is_active"
    type = "S"
  }

  attribute {
    name = "service_owner_team"
    type = "S"
  }

  attribute {
    name = "service_owner_team_POC"
    type = "S"
  }

  attribute {
    name = "committed_sla"
    type = "S"
  }

  attribute {
    name = "monitoring_frequency"
    type = "N"
  }

  attribute {
    name = "region"
    type = "S"
  }

  attribute {
    name = "isGlobalService"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  global_secondary_index {
    name            = "ServiceNameIndex"
    hash_key        = "service_name"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  global_secondary_index {
    name            = "RegistrationDateIndex"
    hash_key        = "registration_date"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  global_secondary_index {
    name            = "ServiceDescriptionIndex"
    hash_key        = "service_description"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  global_secondary_index {
    name            = "ServiceOwnerTeamIndex"
    hash_key        = "service_owner_team"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  global_secondary_index {
    name            = "ServiceOwnerTeamPOCIndex"
    hash_key        = "service_owner_team_POC"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  global_secondary_index {
    name            = "ParentServiceIDIndex"
    hash_key        = "parent_service_id"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  global_secondary_index {
    name            = "MonitoringFrequencyIndex"
    hash_key        = "monitoring_frequency"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }
  global_secondary_index {
    name            = "CommittedSLAIndex"
    hash_key        = "committed_sla"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  global_secondary_index {
    name            = "EnableExternalStatusIndex"
    hash_key        = "enable_external_status"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  global_secondary_index {
    name            = "IsGlobalServiceIndex"
    hash_key        = "isGlobalService"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  global_secondary_index {
    name            = "IsActiveIndex"
    hash_key        = "is_active"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  global_secondary_index {
    name            = "RegionIndex"
    hash_key        = "region"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamodb_key.arn
  }
}

#DynamoDB schema for service_dependency_store
resource "aws_dynamodb_table" "service_dependency_store" {
  name           = "service_dependency_store"
  billing_mode   = local.config_data.data.role.billing_mode
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "service_id"

  attribute {
    name = "service_id"
    type = "S"
  }

  attribute {
    name = "dependent_service_id"
    type = "S"
  }

  attribute {
    name = "record_creation_date"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  global_secondary_index {
    name            = "DependentServiceIdIndex"
    hash_key        = "dependent_service_id"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  global_secondary_index {
    name            = "RecordCreationDateIndex"
    hash_key        = "record_creation_date"
    projection_type = local.config_data.data.GSI.projection_type
    write_capacity  = local.config_data.data.GSI.write_capacity
    read_capacity   = local.config_data.data.GSI.read_capacity
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamodb_key.arn
  }
}