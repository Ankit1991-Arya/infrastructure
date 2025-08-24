terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
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

resource "aws_kms_key" "S3-encryption-key" {
  description         = "KMS key for S3 bucket encryption"
  enable_key_rotation = true
}

resource "aws_s3_bucket" "source-bucket" {
  bucket = "uptime-datapoints"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "S3-encryption-config" {
  bucket = aws_s3_bucket.source-bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.S3-encryption-key.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "uptime-S3-block" {
  bucket                  = aws_s3_bucket.source-bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "uptime-bucket-versioning" {
  bucket = aws_s3_bucket.source-bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "uptime-bucket-logging" {
  bucket        = aws_s3_bucket.source-bucket.bucket
  target_bucket = aws_s3_bucket.source-bucket.bucket
  target_prefix = "log/"
}
module "deployment-s3-bucket-module" {
  source = "./modules/deployment-s3"
  providers = {
    aws = aws.oregon
  }
}