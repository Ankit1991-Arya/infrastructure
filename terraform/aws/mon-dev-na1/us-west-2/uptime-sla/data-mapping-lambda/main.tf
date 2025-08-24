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

module "data-mapping-lambda-us-west-2" {
  source = "./modules/lambda"
  providers = {
    aws = aws.oregon
  }
  data_lambda_config = local.config_data
}
