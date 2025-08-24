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

module "lambda-us-west-2" {
  source = "./modules/lambda"
  providers = {
    aws = aws.oregon
  }
  lambda_config = local.config_data
}

module "sqs-us-west-2" {
  source = "./modules/sqs"
  providers = {
    aws = aws.oregon
  }
  lambda_arn     = module.lambda-us-west-2.consumer_function_output
  dlq_lambda_arn = module.dlq-us-west-2.dlq_function_output
  sqs_config     = local.config_data
}
# to verify

module "dlq-us-west-2" {
  source = "./modules/dlq-lambda"

  providers = {
    aws = aws.oregon
  }
  dlq_arn           = module.sqs-us-west-2.dlq_arn_function_output
  dlq_id            = module.sqs-us-west-2.dlq_id_function_output
  dlq_lambda_config = local.config_data
}