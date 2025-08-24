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
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "DevOps"
      Product             = "ACD-Entitymanagement"
      Service             = "API"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "api-aurora-rds" {
  source  = "spacelift.io/incontact/api-aurora-rds-development/default"
  version = "0.4.22" // Version of the Terraform module to deploy

  // This configuration is intended to grant access to AuroraDB from the developers' workstations
  developers_cidr = "10.21.0.0/18" // Add this only in ic-dev
  cluster_name    = "orch-realtime-api-rds"
  min_acu         = 1
  max_acu         = 60
  instance_count  = 3 // Make sure to change the parameter num_rds_db_instance_ids in api-aurora-rds-alarms module
  // Ensure the thresholds in the alerts module are updated whenever ACUs are changed
  // Pass the variable 'environment' here if a new instance and a new secret need to be created
}

module "api-aurora-rds-alarms" {
  source  = "spacelift.io/incontact/api-aurora-rds-alarms-development/default"
  version = "0.0.14" // Version of the Terraform module to deploy

  num_rds_db_instance_ids = 3
  // Ensure the thresholds for 'network_throughput_threshold' and 'temp_storage_throughput_threshold' are updated whenever ACUs are changed.
  // They are both set to 80 MBps by default.
}

