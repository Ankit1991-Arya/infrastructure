data "aws_iam_policy_document" "allowed_s3_access" {
  statement {
    sid    = "AllowedS3Object"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:ListObjects",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}/*"
    ]
  }
  statement {
    sid    = "AllowedS3Bucket"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetBucketACL",
      "s3:GetEncryptionConfiguration"
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}"
    ]
  }
}