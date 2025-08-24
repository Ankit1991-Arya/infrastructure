resource "aws_kms_key" "S3-encryption-key" {
  description         = "KMS key for S3 bucket encryption"
  enable_key_rotation = true
}
resource "aws_s3_bucket" "lambda-deployment-bucket" {
  bucket = "uptime-calculation-lambda-deployment"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "lambda-deployment-encryption-config" {
  bucket = aws_s3_bucket.lambda-deployment-bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.S3-encryption-key.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "lambda-deployment-S3-block" {
  bucket                  = aws_s3_bucket.lambda-deployment-bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "lambda-deployment-bucket-versioning" {
  bucket = aws_s3_bucket.lambda-deployment-bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "lambda-deployment-bucket-logging" {
  bucket        = aws_s3_bucket.lambda-deployment-bucket.bucket
  target_bucket = aws_s3_bucket.lambda-deployment-bucket.bucket
  target_prefix = "log/"
}