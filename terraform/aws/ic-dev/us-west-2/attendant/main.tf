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
      Product = "ACD"
      Service = "Attendant"
      Name : "Attendant Logs Bucket"
      ApplicationOwner    = "Attendant"
      InfrastructureOwner = "Attendant"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

#tfsec:ignore:aws-s3-enable-bucket-logging We do not need logging for this bucket
#tfsec:ignore:aws-s3-enable-bucket-encryption We do not need encryption
#tfsec:ignore:aws-s3-encryption-customer-key We do not need encryption
resource "aws_s3_bucket" "bucket2" {
  bucket = "attendant-logs-ic-dev-bucket-test-delete"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.attendant_kms_key.key_id
      }
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle2" {
  bucket = aws_s3_bucket.bucket2.id

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
  bucket = aws_s3_bucket.bucket2.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example2" {
  bucket = aws_s3_bucket.bucket2.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_policy" "attendant_logs_bucket_policy2" {
  bucket = aws_s3_bucket.bucket2.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicS3LoggingPutGetObject",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::300813158921:role/ServiceAccess-attendant-api-service"
        },
        "Action" : [
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.bucket2.id}",
          "arn:aws:s3:::${aws_s3_bucket.bucket2.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.bucket2.id}/*/*",
          "arn:aws:s3:::${aws_s3_bucket.bucket2.id}/*/*/*",
          "arn:aws:s3:::${aws_s3_bucket.bucket2.id}/*/*/*/*"
        ]
      }
    ]
  })
}
