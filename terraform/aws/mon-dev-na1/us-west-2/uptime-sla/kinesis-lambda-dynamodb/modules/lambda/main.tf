resource "aws_lambda_function" "uptime-lambda-consumer" {
  filename      = "${path.module}/src.zip"
  function_name = "uptime-lambda-consumer"
  role          = var.lambda_vars.data.role.arn
  handler       = "./src/index.handler"
  runtime       = "nodejs20.x"
}

output "consumer_function_output" {
  value       = aws_lambda_function.uptime-lambda-consumer.arn
  description = "Consumer Function function name"
}