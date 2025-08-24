resource "aws_lambda_function" "uptime-lambda-data-mapping" {
  filename      = "${path.module}/src.zip"
  function_name = "uptime-lambda-data-mapping"
  role          = var.data_lambda_config.data.role.arn
  handler       = "./src/index.handler"
  runtime       = "nodejs20.x"
  timeout       = 120 # 2 minutes
}

resource "aws_cloudwatch_event_rule" "dataMapping-lambda-rule" {
  name                = "dataMapping-rule"
  schedule_expression = "cron(1 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "dataMapping-lambda-target" {
  rule      = aws_cloudwatch_event_rule.dataMapping-lambda-rule.name
  target_id = "uptime-lambda-data-mapping"
  arn       = aws_lambda_function.uptime-lambda-data-mapping.arn
}

resource "aws_lambda_permission" "dataMapping-lambda-allow-permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.uptime-lambda-data-mapping.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.dataMapping-lambda-rule.arn
}

resource "aws_cloudwatch_metric_alarm" "LambdaErrorRateAlarmdataMapping" {
  alarm_name          = "LambdaErrorRateAlarmdataMapping"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alarm when the Lambda function error rate exceeds 1"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-data-mapping.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "LambdaDurationAlarmdataMapping" {
  alarm_name          = "LambdaDurationAlarmdataMapping"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Average"
  threshold           = "120000"
  alarm_description   = "Alarm when the Lambda function duration exceeds 2 minutes"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-data-mapping.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "LambdaIteratorAgeAlarmdataMapping" {
  alarm_name          = "LambdaIteratorAgeAlarmdataMapping"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "IteratorAge"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "60000"
  alarm_description   = "Alarm when the Lambda function iterator age exceeds 60 seconds"
  dimensions = {
    FunctionName = aws_lambda_function.uptime-lambda-data-mapping.function_name
  }
}
