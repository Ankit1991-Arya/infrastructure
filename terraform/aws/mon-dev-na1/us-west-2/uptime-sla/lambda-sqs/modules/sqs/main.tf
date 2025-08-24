resource "aws_sqs_queue" "uptime-dlq" {
  name = "uptime-dlq"
  sqs_managed_sse_enabled = var.sqs_config.data.sqs.sqs_managed_sse_enabled
}

resource "aws_sqs_queue" "uptime-source-queue" {
  name = "uptime-source-queue"
  message_retention_seconds = var.sqs_config.data.sqs.message_retention_seconds
  sqs_managed_sse_enabled = var.sqs_config.data.sqs.sqs_managed_sse_enabled
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.uptime-dlq.arn
    maxReceiveCount     = var.sqs_config.data.sqs.maxReceiveCount
  })
}

resource "aws_lambda_event_source_mapping" "sqs_event_source" {
  event_source_arn = aws_sqs_queue.uptime-source-queue.arn
  function_name    = var.lambda_arn
  batch_size       = var.sqs_config.data.sqs.batch_size
  enabled          = var.sqs_config.data.sqs.enabled
}

resource "aws_lambda_event_source_mapping" "dlq_event_source" {
  event_source_arn = aws_sqs_queue.uptime-dlq.arn
  function_name    = var.dlq_lambda_arn
  batch_size       = var.sqs_config.data.sqs.batch_size
  enabled          = var.sqs_config.data.sqs.enabled
}


resource "aws_sqs_queue_policy" "allow_wfo_access" {
  queue_url = aws_sqs_queue.uptime-source-queue.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id = "CrossSQSPolicy"
    Statement = [
      {
        Sid = "AllowSQSSendMessage"
        Effect = "Allow"
        Principal = {
           "AWS": "arn:aws:iam::934137132601:role/dev-lambda-uh-usc-role"
        }
        Action = "SQS:SendMessage"
        "Resource": "arn:aws:sqs:us-west-2:300101013673:uptime-source-queue"
      }
    ]
  })
}



output "dlq_arn_function_output" {
  value       = aws_sqs_queue.uptime-dlq.arn
  description = "DLQ Function arn"
}

output "dlq_id_function_output" {
  value       = aws_sqs_queue.uptime-dlq.id
  description = "DLQ Function id" 
}