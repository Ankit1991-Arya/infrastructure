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
  region = "me-central-1"
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
  source  = "spacelift.io/incontact/api-aurora-rds/default"
  version = "0.4.18" // Version of the Terraform module to deploy

  environment     = "acae"
  vpc_name_common = "CoreNetwork"
  eks_cidr        = "10.230.208.0/21"
  min_acu         = 1
  max_acu         = 10
  // This configuration is intended to grant access to AuroraDB from the developers' workstations
  developers_cidr     = "10.21.0.0/19"
  deletion_protection = true
  cluster_name        = "orch-realtime-api-rds"
  // Pass the variable 'environment' here if a new instance and a new secret need to be created
}

module "api-aurora-rds-alarms" {
  source  = "spacelift.io/incontact/api-aurora-rds-alarms/default"
  version = "0.0.12" // Version of the Terraform module to deploy

  alarm-sns-topic-name = "entitymanagement_alerts_account_prod"

  // num_rds_db_instance_ids = 3
  // Ensure the thresholds for 'network_throughput_threshold' and 'temp_storage_throughput_threshold' are updated whenever ACUs are changed.
  // They are both set to 80 MBps by default.
}
