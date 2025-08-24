terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

#data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "entitymanagement"
      Service             = "FedRAMP Test"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

# tfsec:ignore:aws-s3-enable-bucket-logging We do not need logging for this bucket
# resource "aws_s3_bucket" "bucket" {
#   bucket        = "do-fedramp-test-entitymanagement"
#   force_destroy = true
# }

# resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
#   bucket = aws_s3_bucket.bucket.id
#   rule {
#     id     = "TransitionRule"
#     status = "Enabled"
#     expiration {
#       days = 10
#     }
#   }
# }

# resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
#   bucket = aws_s3_bucket.bucket.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket_versioning" "bucket_versioning" {
#   bucket = aws_s3_bucket.bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
#   bucket = aws_s3_bucket.bucket.id
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = contains(["300813158921"], data.aws_caller_identity.current.account_id) ? "aws:kms" : "AES256"
#       kms_master_key_id = contains(["300813158921"], data.aws_caller_identity.current.account_id) ? "arn:aws:kms:us-west-2:300813158921:key/e90ac056-eeea-4d41-83cd-6497bf12dc09" : null
#     }
#   }
# }
