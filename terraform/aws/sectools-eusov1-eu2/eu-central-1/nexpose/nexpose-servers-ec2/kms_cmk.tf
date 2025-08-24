data "aws_region" "this" {}
data "aws_caller_identity" "this" {}
# Create Policy document
data "aws_iam_policy_document" "shared_eks_ebs_policy" {
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
    sid = "Allow access through EBS for all principals in the account that are authorized to use EBS"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:Describe*",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      values   = ["ec2.${data.aws_region.this.name}.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.this.account_id]
      variable = "kms:CallerAccount"
    }
  }
}

# Create KMS key 
resource "aws_kms_key" "nexpose_ebs_kms_key" {
  description             = "This KMS key is used for encryption at rest"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.shared_eks_ebs_policy.json
}

# Create Alias for KMS key
resource "aws_kms_alias" "nexpose_ebs_kms_alias" {
  name          = "alias/nexpose-server-ebs"
  target_key_id = aws_kms_key.nexpose_ebs_kms_key.key_id
}