terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.0"
    }
  }
}

data "archive_file" "dailysla_src_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/src.zip"
}

resource "aws_lambda_function" "uptime-lambda-producer" {
  filename         = "${path.module}/src.zip"
  function_name    = "uptime-lambda-producer"
  role             = "arn:aws:iam::300101013673:role/ServiceAccess-sre-uptime-calculation-mon-role"
  handler          = "./src/index.handler"
  runtime          = "nodejs20.x"
  timeout          = 120 # 2 minutes
  memory_size      = 512
  layers           = ["arn:aws:lambda:us-west-2:300101013673:layer:node_modules_layer:2"]
  source_code_hash = data.archive_file.dailysla_src_zip.output_base64sha256
}
