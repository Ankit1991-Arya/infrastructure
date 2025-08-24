terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      ApplicationOwner    = "Reporting CXoneACDReportingBoliviaTeam@nice.com"
      InfrastructureOwner = "Reporting CXoneACDReportingBoliviaTeam@nice.com"
      Product             = "ACD-Reporting"
      Service             = "Reporting Queue"
      Repository          = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

resource "aws_sqs_queue" "scheduler-messages" {
  name                      = "reporting-reports-manager-scheduler-messages"
  sqs_managed_sse_enabled   = true
  message_retention_seconds = 14400
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.scheduler-messages-dlq.arn
    maxReceiveCount     = 20
  })
}

resource "aws_sqs_queue" "scheduler-messages-dlq" {
  name                    = "reporting-reports-manager-scheduler-messages-dlq"
  sqs_managed_sse_enabled = true
}