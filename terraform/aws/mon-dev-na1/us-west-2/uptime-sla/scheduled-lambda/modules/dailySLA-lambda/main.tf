data "archive_file" "dailysla_src_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/src.zip"
}

resource "aws_lambda_function" "uptime-lambda-dailySLA" {
  filename      = "${path.module}/src.zip"
  function_name = "uptime-lambda-dailySLA"
  role          = var.daily_lambda_config.data.role.arn
  handler       = "./src/index.handler"
  runtime       = "nodejs20.x"
  timeout       = 120 # 2 minutes
  source_code_hash = data.archive_file.dailysla_src_zip.output_base64sha256
  layers        = [var.daily_lambda_config.data.layer.arn]
}

resource "aws_cloudwatch_event_rule" "dailySLA-lambda-rule" {
  name                = "dailySLA-rule"
  schedule_expression = "cron(5 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "dailySLA-lambda-target" {
  rule      = aws_cloudwatch_event_rule.dailySLA-lambda-rule.name
  target_id = "uptime-lambda-dailySLA"
  arn       = aws_lambda_function.uptime-lambda-dailySLA.arn
}

resource "aws_lambda_permission" "dailySLA-lambda-allow-permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.uptime-lambda-dailySLA.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.dailySLA-lambda-rule.arn
}

resource "aws_cloudwatch_metric_alarm" "LambdaErrorRateAlarmDailySLA" {
  alarm_name          = "LambdaErrorRateAlarmDailySLA"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alarm when the Lambda function error rate exceeds 1"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-dailySLA.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "LambdaDurationAlarmDailySLA" {
  alarm_name          = "LambdaDurationAlarmDailySLA"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Average"
  threshold           = "120000"
  alarm_description   = "Alarm when the Lambda function duration exceeds 2 minutes"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-dailySLA.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "LambdaIteratorAgeAlarmDailySLA" {
  alarm_name          = "LambdaIteratorAgeAlarmDailySLA"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "IteratorAge"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "60000"
  alarm_description   = "Alarm when the Lambda function iterator age exceeds 60 seconds"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-dailySLA.function_name
  }
}
