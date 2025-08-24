terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.2.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      ApplicationOwner    = "Mono-Repo Provisioners"
      InfrastructureOwner = "Mono-Repo Provisioners"
      Service             = "monorepo-s3-event-handler"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

#tfsec:ignore:aws-s3-enable-bucket-encryption
#tfsec:ignore:aws-s3-encryption-customer-key
#tfsec:ignore:aws-s3-enable-bucket-logging
module "monorepo_lambda" {
  source  = "spacelift.io/incontact/monorepo-s3-event-handler-lambda/default"
  version = "0.3.0"

  lambda_function_name    = "monorepo-s3-event-handler"
  lambda_role_arn         = "arn:aws:iam::300813158921:role/ServiceAccess-monorepo-lambda-s3-event-handler" # TODO: recreate ARN (name inconsistency) once PoC is complete
  s3_zip_bucket           = "do-entitymanagement"
  s3_event_bucket         = "incontact-monorepo-artifacts"
  s3_key                  = "monorepo-s3-event-handler-lambda/development-6-13-2025.zip"
  lambda_memory_megabytes = 128
  lambda_timeout_seconds  = 15

  log_level                 = "INFO"
  fileshare_root            = "\\\\corpfs02\\LATEST"
  webadmins_api_url         = "http://webadmins-dev.in.lab"
  webadmins_api_secret_name = "monorepo-s3-event-handler/webadmins-api-token"
}
