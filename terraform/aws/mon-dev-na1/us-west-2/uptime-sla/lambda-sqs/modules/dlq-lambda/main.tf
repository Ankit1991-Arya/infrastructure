resource "aws_lambda_function" "uptime-lambda-dlq" {
  filename      = "${path.module}/src.zip"
  function_name = "uptime-lambda-dlq"
  role          = var.dlq_lambda_config.data.role.arn
  handler       = "./src/index.handler"
  runtime       = "nodejs20.x"
  memory_size   = 512
  source_code_hash = data.archive_file.dlq_lambda_src_zip.output_base64sha256
  layers        = [var.dlq_lambda_config.data.layer.arn] 
  environment {
    variables = {
      DLQ_URL = var.dlq_id
    }
  }
  dead_letter_config {
    target_arn = var.dlq_arn
  }
}

data "archive_file" "dlq_lambda_src_zip" {
  type        = "zip"
  source_dir = "${path.module}/src"
  output_path = "${path.module}/src.zip"
}

resource "aws_cloudwatch_metric_alarm" "LambdaErrorRateAlarmDLQ" {
  alarm_name          = "LambdaErrorRateAlarmDLQ"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alarm when the Lambda function error rate exceeds 1"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-dlq.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "LambdaDurationAlarmDLQ" {
  alarm_name          = "LambdaDurationAlarmDLQ"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Average"
  threshold           = "120000"
  alarm_description   = "Alarm when the Lambda function duration exceeds 2 minutes"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-dlq.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "LambdaIteratorAgeAlarmDLQ" {
  alarm_name          = "LambdaIteratorAgeAlarmDLQ"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "IteratorAge"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "60000"
  alarm_description   = "Alarm when the Lambda function iterator age exceeds 60 seconds"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-dlq.function_name
  }
}

output "dlq_function_output" {
  value       = aws_lambda_function.uptime-lambda-dlq.arn
  description = "DLQ Function function arn"
}