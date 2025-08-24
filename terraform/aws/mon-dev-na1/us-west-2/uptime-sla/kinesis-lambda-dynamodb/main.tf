terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
  }
}

# locals {
#   config_data = yamldecode(file("./inputs.yaml"))
# }

# module "lambda-us-west-2" {
#   source = "./modules/lambda"
#   providers = {
#     aws = aws.oregon
#   }
#   lambda_vars = local.config_data
# }

# module "kinesis-us-west-2" {
#   source = "./modules/kinesis"
#   providers = {
#     aws = aws.oregon
#   }
#   lambda_arn    = module.lambda-us-west-2.consumer_function_output
#   lambda_config = local.config_data
# }