#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-encryption-customer-key
#tfsec:ignore:aws-s3-enable-bucket-encryption
module "s3_guardduty_bucket" {
  count   = (var.guard_duty_enabled == true && var.guard_duty_s3_bucket_enabled == true) ? 1 : 0
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.6.0"

  bucket = "${var.account_alias}-guardduty-logs"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      "apply_server_side_encryption_by_default" = {
        "kms_master_key_id" : aws_kms_key.guardduty_s3_kms_key[0].id,
        "sse_algorithm" : "aws:kms"
      }
      bucket_key_enabled = true
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "guardduty_lifecycle" {
  count  = (var.guard_duty_enabled == true && var.guard_duty_s3_bucket_enabled == true) ? 1 : 0
  bucket = module.s3_guardduty_bucket[0].s3_bucket_id

  rule {
    id = "expiration"
    expiration {
      days = 2555
    }
    filter {
      prefix = "GuardDuty"
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 120
      storage_class = "GLACIER_IR"
    }
    transition {
      days          = 210
      storage_class = "GLACIER"
    }
    transition {
      days          = 730
      storage_class = "DEEP_ARCHIVE"
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "guardduty_bucket_policy" {
  count  = (var.guard_duty_enabled == true && var.guard_duty_s3_bucket_enabled == true) ? 1 : 0
  bucket = module.s3_guardduty_bucket[0].s3_bucket_id
  policy = data.aws_iam_policy_document.guardduty_s3_bucket_policy[0].json
}

data "aws_iam_policy_document" "guardduty_s3_bucket_policy" {
  count = (var.guard_duty_enabled == true && var.guard_duty_s3_bucket_enabled == true) ? 1 : 0
  statement {
    sid = "guardduty_s3_read"
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketAcl"
    ]
    resources = [
      module.s3_guardduty_bucket[0].s3_bucket_arn,
      "${module.s3_guardduty_bucket[0].s3_bucket_arn}/*"
    ]
    condition {
      test     = "ForAnyValue:StringEquals"
      values   = [data.aws_caller_identity.this.account_id]
      variable = "aws:SourceAccount"
    }
  }

  statement {
    sid = "guardduty_s3_write"
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      module.s3_guardduty_bucket[0].s3_bucket_arn,
      "${module.s3_guardduty_bucket[0].s3_bucket_arn}/*"
    ]
    condition {
      test     = "ForAnyValue:StringEquals"
      values   = [data.aws_caller_identity.this.account_id]
      variable = "aws:SourceAccount"
    }
  }
}