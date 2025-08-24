terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Product             = "Platform"
      Service             = "UptimeEvaluationService"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      InfrastructureOwner = "S and C Platform / Security and Compliance_Earth@nice.com"
      ApplicationOwner    = "S andC Platform / Security and Compliance_Earth@nice.com"
    }
  }
}

locals {
  config_data = yamldecode(file("./spacelift.yaml"))
}

resource "aws_lambda_layer_version" "uptime_lambda_layer" {
  filename            = "${path.module}/nodejs.zip"
  layer_name          = "uptime-layer"
  compatible_runtimes = ["nodejs20.x", "nodejs18.x"]
  #source_code_hash    = data.archive_file.uptime_lambda_layer.output_base64sha256
}

# datapoint api gateway 
#require

resource "aws_api_gateway_rest_api" "api" {
  name        = "uptime-api"
  description = "API Gateway for uptime with endpoints"
}

# datapoint resource
#require
resource "aws_api_gateway_resource" "resource1" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "datapoint"
}

#require
# datapoint method

resource "aws_api_gateway_method" "method1" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource1.id
  http_method   = "GET"
  authorization = "NONE"
}

# datapoint integration
#require
resource "aws_api_gateway_integration" "integration1" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource1.id
  http_method             = aws_api_gateway_method.method1.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.uptime_by_service_lambda.invoke_arn
}

#uptime-by-service
#require

resource "aws_lambda_function" "uptime_by_service_lambda" {
  filename         = "uptime-by-service.zip"
  function_name    = "uptime-lambda-byService"
  role             = local.config_data.data.role_and_policy.role_arn
  handler          = "uptime-by-service.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.uptime_by_service_lambda_zip.output_base64sha256
  layers           = [local.config_data.data.layer.arn]
  memory_size      = 256
  timeout          = 600
  environment {
    variables = {
      region = "us-west-2",
      Bucket = "uptime-datapoints"
    }
  }
}

#require
data "archive_file" "uptime_by_service_lambda_zip" {
  type        = "zip"
  source_file = "../apigateway-lambda/source/handlers/uptime-by-service.js"
  output_path = "${path.module}/uptime-by-service.zip"
}

#require

resource "aws_cloudwatch_log_group" "uptime_by_service_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.uptime_by_service_lambda.function_name}"
  retention_in_days = 14
}

resource "aws_api_gateway_deployment" "dev_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "dev"
  depends_on  = [aws_api_gateway_integration.integration1]
}

resource "aws_api_gateway_deployment" "prod_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
  depends_on  = [aws_api_gateway_integration.integration1]
}


resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "/aws/apigateway/${aws_api_gateway_rest_api.api.name}"
  retention_in_days = 14
}

# resource "aws_api_gateway_method_settings" "name" {
#   stage_name  = "dev"
#   method_path = "*/*"
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   settings {
#     metrics_enabled    = true
#     logging_level      = "INFO"
#     data_trace_enabled = true
#   }
# 
# }

# Lambda function to invoke jenkins Lambda function
resource "aws_lambda_function" "uptime-lambda-schedular" {
  filename         = "invoke-lambda.zip"
  function_name    = "uptime-lambda-schedular"
  role             = local.config_data.data.role_and_policy.role_arn
  handler          = "invoke-lambda.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.jenkins_invoke_lambda_zip.output_base64sha256
  layers           = [local.config_data.data.layer.arn]
  memory_size      = 256
  timeout          = 600
}


data "archive_file" "jenkins_invoke_lambda_zip" {
  type        = "zip"
  source_file = "../apigateway-lambda/source/handlers/invoke-lambda.js"
  output_path = "${path.module}/invoke-lambda.zip"
}

# Lambda permission to allow API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "uptime_allow_assumed_role" {
  statement_id  = "invokeThroughAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "uptime-lambda-byService"
  principal     = local.config_data.data.role_and_policy.role_arn
}

resource "aws_lambda_function" "uptime_for_mimir" {
  filename         = "uptime-lambda-mimir.zip"
  function_name    = "uptime-lambda-mimir"
  role             = local.config_data.data.role_and_policy.role_arn
  handler          = "mimir.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.uptime_for_mimir_zip.output_base64sha256
  layers           = [local.config_data.data.layer.arn]
  memory_size      = 256
  timeout          = 540
  vpc_config {
    subnet_ids         = ["subnet-0d0e55f367c55a784", "subnet-0d26116b82f4c62a8"]
    security_group_ids = ["sg-053e02252caa26080", "sg-09084444e8543c16d", "sg-044c539dae55be6dc", "sg-0321ef4d471ec60e0"]
  }
  environment {
    variables = {
      URL   = "https://grafana-ingress-623632499.us-west-2.elb.amazonaws.com/api/ds/query",
      QUEUE = "https://sqs.us-west-2.amazonaws.com/300101013673/uptime-source-queue",
      TOKEN = "glsa_9UGkIuWnopMEJg3o3eveknqgrsJDBFP8_c55bb852"
    }
  }
}

data "archive_file" "uptime_for_mimir_zip" {
  type        = "zip"
  source_file = "../apigateway-lambda/source/handlers/mimir.js"
  output_path = "${path.module}/uptime-lambda-mimir.zip"
}

resource "aws_cloudwatch_log_group" "uptime_for_mimir_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.uptime_for_mimir.function_name}"
  retention_in_days = 14
}