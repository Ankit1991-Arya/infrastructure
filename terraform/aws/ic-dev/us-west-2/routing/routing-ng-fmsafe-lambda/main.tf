
terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}


provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      InfrastructureOwner : "routingng@NiceinContact.com"
      Product : "Routing-NG"
      Repository = "https://github.com/inContact/infrastructure-live"
    }
  }
}


module "lambda_function_container_image" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.6.0"

  create_current_version_allowed_triggers = var.create_current_version_allowed_triggers
  create_package                          = var.create_package
  create_role                             = var.create_role
  description                             = var.description
  function_name                           = var.function_name
  image_uri                               = "${var.ecr_image}:${var.image_tag}"
  lambda_role                             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.role_name}"
  package_type                            = var.package_type
  timeout                                 = var.timeout
  handler                                 = "handleRequest"
  memory_size                             = 512
  allowed_triggers = {
    kinesis = {
      principal  = "kinesis.amazonaws.com"
      source_arn = data.aws_kinesis_stream.stream.arn
    }
  }
  vpc_security_group_ids = [aws_security_group.fmsafe-lambda-sg.id]
  vpc_subnet_ids         = data.aws_db_subnet_group.routing-ng-subnet.subnet_ids
}

resource "aws_lambda_event_source_mapping" "fmlambda_invoke" {
  event_source_arn  = data.aws_kinesis_stream.stream.arn
  function_name     = module.lambda_function_container_image.lambda_function_arn
  starting_position = "TRIM_HORIZON"
}

data "aws_caller_identity" "current" {}
