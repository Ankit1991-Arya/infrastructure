terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

locals {
  region     = "us-west-2"
  account_id = "265671366761"
  prefix     = "to"
  rate       = "1000 days"
}

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "entitymanagement"
      Service             = "FedRAMP Test"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

# Lambda function definition
resource "aws_lambda_function" "backup_dynamo_db_table" {
  function_name = "entitymanagement-backup-BackupDynamoDBTable"
  role          = "arn:aws:iam::${local.account_id}:role/ServiceAccess-entitymanagement-backup-resource"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      SOURCE_TABLE = "${local.prefix}-entitymanagement-state"
    }
  }
}

# CloudWatch Event Rule to trigger Lambda periodically
resource "aws_cloudwatch_event_rule" "lambda_trigger_rule" {
  name                = "BackupDynamoDBTableRule"
  description         = "Event rule to trigger the Lambda function periodically"
  schedule_expression = "rate(${local.rate})"
}

# CloudWatch Event Target to link the rule with the Lambda function
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.lambda_trigger_rule.name
  arn  = aws_lambda_function.backup_dynamo_db_table.arn
  input = jsonencode({
    SourceTable = "${local.prefix}-entitymanagement-state"
  })
}
