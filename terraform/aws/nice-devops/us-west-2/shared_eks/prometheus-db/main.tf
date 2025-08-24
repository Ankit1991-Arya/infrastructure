terraform {
  required_version = ">= 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

#
# Shared EKS Prometheus DB
#
module "prometheus_db" {
  source = "github.com/inContact/infrastructure-live.git//modules/aws-prometheus-db?ref=v1.2.0"

  alias                = "shared_eks01"
  product              = "kubernetes"
  infrastructure_owner = "devops-cloud-native-core@NiceinContact.com"
  log_group_name       = "/aws/amp/shared_eks01"
  create_log_group     = true
}
