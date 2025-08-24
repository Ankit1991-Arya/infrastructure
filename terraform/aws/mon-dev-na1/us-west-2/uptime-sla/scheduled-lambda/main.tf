terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
  }
}

locals {
  config_data = yamldecode(file("./inputs.yaml"))
}

module "daily-lambda-us-west-2" {
  source = "./modules/dailySLA-lambda"
  providers = {
    aws = aws.oregon
  }
  daily_lambda_config = local.config_data
}

module "monthly-lambda-us-west-2" {
  source = "./modules/monthlySLA-lambda"
  providers = {
    aws = aws.oregon
  }
  monthly_lambda_config = local.config_data
}

module "daily-cleanup-ambda-us-west-2" {
  source = "./modules/cleanup-lambda"
  providers = {
    aws = aws.oregon
  }
  cleanup_lambda_config = local.config_data
}

module "servicesupdate-lambda-us-west-2" {
  source = "./modules/servicesLatest-lambda"
  providers = {
    aws = aws.oregon
  }
  services_lambda_config = local.config_data
}
