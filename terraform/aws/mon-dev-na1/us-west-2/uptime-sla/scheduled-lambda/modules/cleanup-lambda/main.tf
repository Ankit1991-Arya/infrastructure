data "archive_file" "cleanup_src_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/src.zip"
}


resource "aws_lambda_function" "uptime-lambda-daily-cleanup" {
  filename      = "${path.module}/src.zip"
  function_name = "uptime-lambda-daily-cleanup"
  role          = var.cleanup_lambda_config.data.role.arn
  handler       = "./src/index.handler"
  runtime       = "nodejs20.x"
  timeout       = 120 # 2 minutes
  source_code_hash = data.archive_file.cleanup_src_zip.output_base64sha256
  layers        = [var.cleanup_lambda_config.data.layer.arn]
}

resource "aws_cloudwatch_event_rule" "daily-cleanup-lambda-rule" {
  name                = "daily-cleanup-rule"
  schedule_expression = "cron(1 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "daily-cleanup-lambda-target" {
  rule      = aws_cloudwatch_event_rule.daily-cleanup-lambda-rule.name
  target_id = "uptime-lambda-daily-cleanup"
  arn       = aws_lambda_function.uptime-lambda-daily-cleanup.arn
}

resource "aws_lambda_permission" "daily-cleanup-lambda-allow-permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.uptime-lambda-daily-cleanup.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily-cleanup-lambda-rule.arn
}
resource "aws_cloudwatch_metric_alarm" "LambdaErrorRateAlarmCleanup" {
  alarm_name          = "LambdaErrorRateAlarmCleanup"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alarm when the Lambda function error rate exceeds 1"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-daily-cleanup.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "LambdaDurationAlarmCleanup" {
  alarm_name          = "LambdaDurationAlarmCleanup"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Average"
  threshold           = "120000"
  alarm_description   = "Alarm when the Lambda function duration exceeds 2 minutes"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-daily-cleanup.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "LambdaIteratorAgeAlarmCleanup" {
  alarm_name          = "LambdaIteratorAgeAlarmCleanup"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "IteratorAge"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "60000"
  alarm_description   = "Alarm when the Lambda function iterator age exceeds 60 seconds"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-daily-cleanup.function_name
  }
}
