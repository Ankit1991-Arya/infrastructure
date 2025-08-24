resource "aws_lambda_function" "uptime-lambda-consumer" {
  filename      = "${path.module}/src.zip"
  function_name = "uptime-lambda-consumer"
  role          = var.lambda_config.data.role.arn
  handler       = "./src/index.handler"
  runtime       = "nodejs20.x"
  memory_size   = 512
  source_code_hash = data.archive_file.consumer_lambda_src_zip.output_base64sha256
  layers        = [var.lambda_config.data.layer.arn] 
}

data "archive_file" "consumer_lambda_src_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/src.zip"
}

output "consumer_function_output" {
  value       = aws_lambda_function.uptime-lambda-consumer.arn
  description = "Consumer Function function name"
}
