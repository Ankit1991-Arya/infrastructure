terraform {
  required_version = ">= 1.3.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "acddevops-lambda-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = var.bucket_name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  versioning = {
    enabled = true
  }

  logging = {
    target_bucket = var.logs_s3_bucket_id
    target_prefix = "S3Logs/"
  }

  lifecycle_rule = [
    {
      id                                     = "export"
      enabled                                = true
      abort_incomplete_multipart_upload_days = 3

      noncurrent_version_expiration = {
        days = 7
      }
    }
  ]

  server_side_encryption_configuration = {
    rule = {
      "apply_server_side_encryption_by_default" = {
        "sse_algorithm" : "AES256"
      }
      bucket_key_enabled = true
    }
  }
}