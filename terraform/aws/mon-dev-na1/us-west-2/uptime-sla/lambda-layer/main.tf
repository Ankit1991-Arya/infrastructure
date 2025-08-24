terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
  }
}

resource "aws_lambda_layer_version" "node_modules_layer" {
  layer_name          = "node_modules_layer"
  description         = "Lambda layer for Node.js dependencies"
  compatible_runtimes = ["nodejs20.x"]
  filename            = "nodejs.zip"
  source_code_hash    = filebase64sha256("nodejs.zip")
}

output "lambda_layer_arn" {
  value = aws_lambda_layer_version.node_modules_layer.arn
}

output "lambda_layer_version" {
  value = aws_lambda_layer_version.node_modules_layer.version
}
