terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "us-west-2"
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


# # Configure the SQS queue
# resource "aws_sqs_queue" "orch_entity_fedramp_test_queue" {
#   name                      = "entitymanagement-Matches-fedramp-test"
#   message_retention_seconds = 1800 # 30 minutes
#   kms_master_key_id         = data.aws_kms_key.sqs_aws_kms_key.key_id
# }


# # Configure the Lambda function to send messages to the SQS queue
# resource "aws_lambda_function" "entitymanagement_fedramp_test" {
#   function_name = "entitymanagement-sqs-fedramp-test"
#   role          = "arn:aws:iam::300813158921:role/Role-service-entitymanagement-findmatch-sqs-queue-reader"
#   handler       = "index.lambda_handler"
#   runtime       = "python3.9"


#   filename = "lambda_function_payload.zip"

#   source_code_hash = filebase64sha256("lambda_function_payload.zip")

#   environment {
#     variables = {
#       SQS_QUEUE_URL = aws_sqs_queue.orch_entity_fedramp_test_queue.url
#     }
#   }
# }

# # Configuration of CloudWatch Event Rule to trigger the Lambda function every minute
# resource "aws_cloudwatch_event_rule" "every_minute" {
#   name                = "every-minute"
#   description         = "Event rule to trigger the lambda per minute"
#   schedule_expression = "rate(1 minute)"
# }

# # This resource configures an AWS CloudWatch Event Target that triggers a Lambda function.
# resource "aws_cloudwatch_event_target" "lambda_target" {
#   rule      = aws_cloudwatch_event_rule.every_minute.name
#   target_id = "lambda"
#   arn       = aws_lambda_function.entitymanagement_fedramp_test.arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.entitymanagement_fedramp_test.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.every_minute.arn
# }

# # Configure the Lambda function to read from the SQS queue using kms key
# resource "aws_lambda_function" "entitymanagement_findmatch_event_reader" {
#   function_name = "entitymanagement-findmatch-event-queue-reader-fedramp-test"
#   role          = "arn:aws:iam::300813158921:role/Role-service-entitymanagement-findmatch-sqs-queue-reader"
#   handler       = "reader.lambda_handler"
#   runtime       = "python3.9"
#   timeout       = 30

#   filename = "reader_lambda_function.zip"

#   source_code_hash = filebase64sha256("reader_lambda_function.zip")

#   environment {
#     variables = {
#       OrchestrationAddr = "entitymanagement-na1.omnichannel.dev.internal:9884"
#       SqsQueueName      = "entitymanagement-Matches-fedramp-test"
#     }
#   }

#   kms_key_arn = "arn:aws:kms:us-west-2:300813158921:key/cc45ecb2-da29-4125-b7b3-89380d4c0c79"
# }

# # Configure the event source mapping
# resource "aws_lambda_event_source_mapping" "sqs_findmatch_event_mapping" {
#   batch_size       = 10
#   event_source_arn = aws_sqs_queue.orch_entity_fedramp_test_queue.arn
#   enabled          = true
#   function_name    = aws_lambda_function.entitymanagement_findmatch_event_reader.arn
# }

# #tfsec:ignore:aws-s3-enable-bucket-logging We do not need logging for this bucket
# #tfsec:ignore:aws-s3-enable-bucket-encryption We do not need encryption
# #tfsec:ignore:aws-s3-encryption-customer-key We do not need encryption
# resource "aws_s3_bucket" "backup_bucket" {
#   bucket = "entitymanagement-backup-bucket-fedramp-test"
# }

# resource "aws_s3_bucket_public_access_block" "backup_bucket_public_access_block" {
#   bucket = aws_s3_bucket.backup_bucket.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
#   bucket = aws_s3_bucket.backup_bucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = "aws:kms"
#       kms_master_key_id = "arn:aws:kms:us-west-2:300813158921:key/b5a55f7d-975a-433e-a3a0-6cdfe8abca10"
#     }
#   }
# }

# resource "aws_s3_bucket_versioning" "backup_bucket_versioning" {
#   bucket = aws_s3_bucket.backup_bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# # Define the Lambda function to backup data to S3
# resource "aws_lambda_function" "backup_to_s3" {
#   function_name = "entitymanagement-backup-sqs-to-s3"
#   role          = "arn:aws:iam::300813158921:role/Role-service-entitymanagement-findmatch-sqs-queue-reader"
#   handler       = "sqs_to_s3_lambda_function.lambda_handler"
#   runtime       = "python3.9"
#   timeout       = 60

#   filename = "sqs_to_s3_lambda_function.zip"

#   source_code_hash = filebase64sha256("sqs_to_s3_lambda_function.zip")

#   environment {
#     variables = {
#       SQS_QUEUE_URL = aws_sqs_queue.orch_entity_fedramp_test_queue.url
#       BACKUP_BUCKET = aws_s3_bucket.backup_bucket.bucket
#     }
#   }

#   kms_key_arn = "arn:aws:kms:us-west-2:300813158921:key/cc45ecb2-da29-4125-b7b3-89380d4c0c79"
# }

# # CloudWatch Event Rule to trigger the backup Lambda function periodically
# resource "aws_cloudwatch_event_rule" "backup_lambda_trigger_rule" {
#   name                = "BackupToS3Rule"
#   description         = "Event rule to trigger the Lambda function periodically"
#   schedule_expression = "rate(5 minutes)"
# }

# # CloudWatch Event Target to link the rule with the Lambda function
# resource "aws_cloudwatch_event_target" "sqs_to_s3_lambda_target" {
#   rule      = aws_cloudwatch_event_rule.backup_lambda_trigger_rule.name
#   target_id = "lambda"
#   arn       = aws_lambda_function.backup_to_s3.arn
# }

# # Lambda permission to allow CloudWatch to invoke the Lambda function
# resource "aws_lambda_permission" "allow_cloudwatch_to_call_sqs_to_s3_lambda" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.backup_to_s3.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.backup_lambda_trigger_rule.arn
# }
