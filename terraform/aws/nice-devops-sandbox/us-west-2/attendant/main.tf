terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Owner   = "Attendant"
      Product = "ACD"
      Repo    = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 11
  enable_key_rotation     = true
}

#tfsec:ignore:aws-s3-enable-bucket-logging We do not need logging for this bucket
#tfsec:ignore:aws-s3-enable-bucket-encryption We do not need encryption
#tfsec:ignore:aws-s3-encryption-customer-key We do not need encryption
resource "aws_s3_bucket" "bucket" {
  bucket = "attendant-logs-sandbox-bucket"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle2" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id     = "IntelligentTieringRule"
    status = "Enabled"

    transition {
      days          = 365
      storage_class = "INTELLIGENT_TIERING"
    }

    transition {
      days          = 730
      storage_class = "DEEP_ARCHIVE"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "example2" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example2" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_policy" "attendant_logs_bucket_policy2" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicS3LoggingPutGetObject",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::492216899484:role/Role-service-attendant-cluster-ec2"
        },
        "Action" : [
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*/*",
          "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*/*/*",
          "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*/*/*/*"
        ]
      }
    ]
  })
}