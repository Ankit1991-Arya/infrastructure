data "aws_caller_identity" "this" {}

# Create Policy document
data "aws_iam_policy_document" "guardduty_s3_bucket_kms_policy" {
  statement {
    sid = "Allow administration of the key"
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
      type        = "AWS"
    }
    actions = [
      "kms:*",
    ]
    resources = ["*"]
  }
  statement {
    sid = "Allow GuardDuty to encrypt logs"
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.this.account_id]
      variable = "aws:SourceAccount"
    }
  }
  statement {
    sid = "Allow Logscale to read logs"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions = [
      "kms:Decrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      values   = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/logscale_*"]
      variable = "aws:PrincipalArn"
    }
  }
}

# Create KMS key 
resource "aws_kms_key" "guardduty_s3_kms_key" {
  count                   = (var.guard_duty_enabled == true && var.guard_duty_s3_bucket_enabled == true) ? 1 : 0
  description             = "This KMS key is used for encryption at rest"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.guardduty_s3_bucket_kms_policy.json
}

# Create Alias for KMS key
resource "aws_kms_alias" "guardduty_s3_kms_key_alias" {
  count         = (var.guard_duty_enabled == true && var.guard_duty_s3_bucket_enabled == true) ? 1 : 0
  name          = "alias/guardduty-s3-bucket-key"
  target_key_id = aws_kms_key.guardduty_s3_kms_key[0].id
}