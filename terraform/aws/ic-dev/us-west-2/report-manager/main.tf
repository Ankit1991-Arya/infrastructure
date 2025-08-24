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
  region = "us-west-2"
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

#tfsec:ignore:aws-sqs-queue-encryption-use-cmk
resource "aws_sqs_queue" "scheduler-messages" {
  name                      = "reporting-reports-manager-scheduler-messages"
  kms_master_key_id         = data.aws_kms_key.sqs_kms_key.key_id
  message_retention_seconds = 14400
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.scheduler-messages-dlq.arn
    maxReceiveCount     = 20
  })
}

#tfsec:ignore:aws-sqs-queue-encryption-use-cmk
resource "aws_sqs_queue" "scheduler-messages-dlq" {
  name              = "reporting-reports-manager-scheduler-messages-dlq"
  kms_master_key_id = data.aws_kms_key.sqs_kms_key.key_id
}
